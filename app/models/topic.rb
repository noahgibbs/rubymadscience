class Topic
    TOPIC_KEYS = [:name, :desc, :thumbnail_url, :bigthumb_url, :fullsize_url, :id, :data, :steps, :created_at, :updated_at]
    STEP_KEYS = [:name, :desc, :url, :id, :type, :data]
    STEP_TYPES = [:video, :blog, :blog_and_video]
    TOPIC_ROOT = File.join(Rails.root, "app", "models", "topics")

    # This is how we do the view mapping of type to output markup
    PARTIAL_BY_TYPE = {
        "blog" => "step_blog",
        "video" => "step_video",
        "blog_and_video" => "step_blog_and_video",
    }

    TopicStruct = Struct.new(*TOPIC_KEYS, keyword_init: true) do
        # Helper methods can go here
    end

    StepStruct = Struct.new(*STEP_KEYS, keyword_init: true) do
        # Helper methods can go here
    end

    def self.all
        root_path = File.join(TOPIC_ROOT, "*.json")
        objs = Dir[root_path].map do |topic_file|
            load_topic_from_json(File.read(topic_file), created: File.ctime(topic_file), updated: File.mtime(topic_file), id: File.basename(topic_file, ".json"))
        end
        objs
    end

    def self.find(topic_id)
        filename = File.join(TOPIC_ROOT, "#{topic_id.downcase}.json")
        load_topic_from_json(File.read(filename), created: File.ctime(filename), updated: File.mtime(filename), id: topic_id)
    end

    def self.load_topic_from_json(json_string_data, created:, updated:, id:)
        raw_objs = JSON.load(json_string_data)
        illegal_keys = raw_objs.keys - TOPIC_KEYS.map(&:to_s)
        raise("Illegal keys in topic: #{illegal_keys.inspect}!") unless illegal_keys.empty?

        steps = raw_objs["steps"].map do |step_objs|
            unless STEP_TYPES.map(&:to_s).include?(step_objs["type"])
                raise("Illegal type #{step_objs["type"].inspect} for step object!")
            end
            StepStruct.new name: step_objs["name"],
                desc: step_objs["desc"],
                url: step_objs["url"],
                id: "#{id}/#{step_objs["id"]}",
                type: step_objs["type"],
                data: step_objs["data"]
        end

        args = {}
        TOPIC_KEYS.each { |tk| args[tk] = raw_objs[tk.to_s] }
        TopicStruct.new args.merge({
            steps: steps,
            id: id,
            created_at: created,
            updated_at: updated
            })
    end
end
