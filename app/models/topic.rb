class Topic
    TOPIC_KEYS = [:name, :desc, :thumbnail_url, :bigthumb_url, :fullsize_url, :id, :data, :steps, :created_at, :updated_at]
    STEP_KEYS = [:name, :desc, :url, :id, :type, :data]
    STEP_TYPES = [:video, :blog, :blog_and_video]
    DEFAULT_TOPIC_ROOT = File.join(Rails.root, "app", "models", "topics")

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

    def self.topic_root=(new_root)
        @topic_root = new_root
    end

    def self.topic_root
        @topic_root ||= DEFAULT_TOPIC_ROOT
    end

    def self.topic_from_file(topic_file)
        @file_cache ||= {}
        if @file_cache[topic_file] && @file_cache[topic_file][:mtime] == File.mtime(topic_file)
            return @file_cache[topic_file][:topic]
        end
        ct = File.ctime(topic_file)
        mt = File.mtime(topic_file)
        tid = File.basename(topic_file, ".json")
        t = load_topic_from_json(File.read(topic_file), created: ct, updated: mt, id: tid)
        @file_cache[topic_file] = {
            ctime: ct,
            mtime: mt,
            topic: t,
            id: tid,
        }
        t
    end

    def self.all
        root_path = File.join(topic_root, "*.json")
        objs = Dir[root_path].map do |topic_file|
            topic_from_file(topic_file)
        end
        objs
    end

    def self.find(topic_id)
        filename = File.join(topic_root, "#{topic_id.downcase}.json")
        topic_from_file(filename)
    end

    def self.load_topic_from_json(json_string_data, created:, updated:, id:)
        raw_objs = JSON.load(json_string_data)
        illegal_keys = raw_objs.keys - TOPIC_KEYS.map(&:to_s)
        raise("Illegal keys in topic: #{illegal_keys.inspect}!") unless illegal_keys.empty?

        step_ids = raw_objs["steps"].map { |so| so["id"] }
        dup_ids = step_ids.select{ |e| step_ids.count(e) > 1 }.uniq
        raise("Duplicate step IDs in topic: #{dup_ids.inspect}!") unless dup_ids.empty?

        steps = raw_objs["steps"].map do |step_objs|
            unless STEP_TYPES.map(&:to_s).include?(step_objs["type"])
                raise("Illegal type #{step_objs["type"].inspect} for step object!")
            end
            StepStruct.new name: step_objs["name"].freeze,
                desc: step_objs["desc"].freeze,
                url: step_objs["url"].freeze,
                id: "#{id}/#{step_objs["id"]}".freeze,
                type: step_objs["type"].freeze,
                data: step_objs["data"].freeze
        end
        steps.map(&:freeze)

        args = {}
        TOPIC_KEYS.each { |tk| args[tk] = raw_objs[tk.to_s].freeze }
        ts = TopicStruct.new args.merge({
            steps: steps.freeze,
            id: id.freeze,
            created_at: created.freeze,
            updated_at: updated.freeze,
            })
        ts.freeze
        ts
    end
end
