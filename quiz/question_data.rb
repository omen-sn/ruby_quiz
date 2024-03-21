module Quiz
    class QuestionData
        attr_accessor :collection
        attr_reader :yaml_dir, :in_ext, :threads

        def initialize(yaml_dir: File.join(__dir__, 'yml'), in_ext: 'yml')
            @yaml_dir = yaml_dir
            @in_ext = in_ext
            @collection = []
            @threads = []
            load_data
        end

        def to_yaml
            @collection.map(&:to_h).to_yaml
        end

        def save_to_yaml(filename = 'questions_output.yaml')
            File.write(prepare_filename(filename), to_yaml)
        end

        def to_json
            JSON.pretty_generate(@collection.map(&:to_h))
        end

        def save_to_json(filename = 'questions_output.json')
            File.write(prepare_filename(filename), to_json)
        end

        def prepare_filename(filename)
            File.expand_path(filename, __dir__)
        end

        def each_file
            Dir.glob(File.join(@yaml_dir, "*.#{@in_ext}")) do |filename|
                yield filename
            end
        end

        def in_thread(&block)
            @threads << Thread.new { block.call }
        end

        def load_data
            each_file do |filename|
                in_thread { load_from(filename) }
            end
            @threads.each(&:join)
        end

        def load_from(filename)
            questions = YAML.load_file(filename)
            questions.each do |question|
                @collection << Question.new(question['question'], question['answers'])
            end
        end
    end
end

