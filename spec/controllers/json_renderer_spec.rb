require "spec_helper_controllers"
require "controllers/json_renderer"

class TestController
  include JsonRenderer
end

describe JsonRenderer do
  let(:controller) { TestController.new }

  describe "created" do
    it "renders success with 'created' and json object" do
      object = {id: 4}

      expect(controller).to receive(:render).with({
        json: {id: 4},
        status: :created
      })

      controller.created object
    end

    it "renders head with 'created' when no object given" do
      expect(controller).to receive(:head).with :created
      controller.created
    end
  end

  describe "no_content" do
    it "renders head with 'no_content'" do
      expect(controller).to receive(:head).with :no_content
      controller.no_content
    end
  end

  describe "ok" do
    it "renders success with 'ok' and json object/options" do
      object = {name: "test"}
      options = {root: false}

      expect(controller).to receive(:render).with({
        json: {name: "test"},
        status: :ok,
        root: false
      })

      controller.ok object, options
    end

    it "renders head with 'ok' when no object" do
      expect(controller).to receive(:head).with :ok
      controller.ok
    end
  end

  %w(forbidden not_found unauthorized).each do |method_name|
    describe method_name do
      it "renders failure with given message" do
        expect(controller).to receive(:render).with({
          json: {message: "not allowed"},
          status: method_name.to_sym
        })

        controller.send method_name, "not allowed"
      end
    end
  end

  describe "unprocessable" do
    it "renders failure with given message" do
      expect(controller).to receive(:render).with({
        json: {message: ""},
        status: :unprocessable_entity
      })

      controller.unprocessable
    end
  end
end
