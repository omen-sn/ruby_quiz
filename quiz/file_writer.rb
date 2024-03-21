module Quiz
    class FileWriter
        def initialize(mode, filename, answers_dir = 'answers')
            @mode = mode
            @filename = filename
            @answers_dir = answers_dir
        end

        def write(message)
            File.open(prepare_filename(@filename), @mode) do |file|
                file.puts(message)
            end
        end

        def prepare_filename(filename)
            answers_path = Pathname.new(File.join(__dir__, @answers_dir))
            FileUtils.mkdir_p(answers_path) unless Dir.exist?(answers_path)
            File.join(answers_path, filename)
        end
    end
end
