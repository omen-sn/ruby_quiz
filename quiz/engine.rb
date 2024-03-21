module Quiz
    class Engine
      def initialize
        @question_data = Quiz::QuestionData.new(yaml_dir: Quiz::Config.instance.yaml_dir)
        @input_reader = Quiz::InputReader.new
        @writer = Quiz::FileWriter.new('a+', "answers_#{Time.now.strftime('%Y%m%d%H%M%S')}.txt")
        @statistics = Quiz::Statistics.new(@writer)
        user_name = @input_reader.read(welcome_message: "Будь ласка, введіть ваше ім'я:", error_message: "Ім'я не може бути порожнім.", validator: ->(input) { !input.empty? })
        current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        @writer.write("Тест розпочато користувачем #{user_name} о #{current_time}")
      end
  
      def run
        start_time = Time.now
        shuffled_questions = @question_data.collection.shuffle
        shuffled_questions.each do |question|
          puts question.to_s
          puts question.display_answers
          value, user_answer = get_answer_by_char(question)
          correct_answer = question.question_correct_answer
          check(user_answer, correct_answer)
          @writer.write("Question: #{question.to_s}, Your answer: #{user_answer}, Correct answer: #{correct_answer}")
        end
        end_time = Time.now
        elapsed_time = end_time - start_time
        @statistics.print_report
        puts "Тест завершено за #{elapsed_time.round(2)} секунд."
        @writer.write("Тест завершено о #{end_time.strftime('%Y-%m-%d %H:%M:%S')}")
      end

      def check(user_answer, correct_answer)
        if user_answer == correct_answer
          @statistics.correct_answer
        else
          @statistics.incorrect_answer
        end
      end
  
      def get_answer_by_char(question)
        answer = nil
        until answer
          char = @input_reader.read(welcome_message: "Введіть вашу відповідь (A, B, C, D):", error_message: "Неправильне введення. Будь ласка, введіть валідну літеру.", validator: ->(input) { ('A'..'D').include?(input.upcase) && !input.empty? }).upcase
          answer = question.find_answer_by_char(char)
        end
        [answer, char]
      end
    end
  end
  