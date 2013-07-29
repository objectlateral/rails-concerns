require "spec_helper"
require "mailers/resqued_delivery"

class WidgetMailer < ActionMailer::Base
  include ResquedDelivery

  def confirmation widget_id; end

  private

  def not_action_method; end
end

describe ResquedDelivery do
  it "adds a 'queue' ivar and sets it to 'email'" do
    expect(WidgetMailer.instance_variable_get :@queue).to eq :email
  end

  it "adds a `perform` class method that is used by Resque to deliver mail" do
    mailer = double.as_null_object
    expect(WidgetMailer).to receive(:new).with("confirmation", 13).and_return mailer
    expect(mailer).to receive(:deliver!)
    WidgetMailer.perform "confirmation", 13
  end

  describe "intercepting mailer action methods & inserting Resque call" do
    before do
      stub_const "Rails", Class.new
      stub_const "Resque", Class.new
      Rails.stub_chain(:env, :test?).and_return false
    end

    it "sends to Resque when missed method is an action method" do
      expect(Resque).to receive(:enqueue).with WidgetMailer, :confirmation, 1
      message = WidgetMailer.confirmation 1
      message.deliver
    end

    it "doesn't send to Resque when Rails env is test" do
      Rails.stub_chain(:env, :test?).and_return true
      expect(Resque).to_not receive :enqueue
      message = WidgetMailer.confirmation 1
      message.deliver
    end

    it "doesn't send to Resque when missed method is not an action method" do
      expect(Resque).to_not receive :enqueue
      expect {
        WidgetMailer.not_action_method
      }.to raise_error NoMethodError
    end
  end
end
