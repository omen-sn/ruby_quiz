module Quiz
    class Question
        attr_accessor :question_body, :question_correct_answer, :question_answers

        def initialize(raw_text, raw_answers)
            @question_body = raw_text
            @question_answers = {}
            @question_correct_answer = nil
            load_answers(raw_answers)
        end

        def display_answers
            @question_answers.map { |char, answer| "#{char}. #{answer}" }.join("\n")
        end

        def to_s
            @question_body
        end

        def to_h
            {
            question_body: @question_body,
            question_correct_answer: @question_correct_answer,
            question_answers: @question_answers
            }
        end

        def to_json(*_args)
            JSON.pretty_generate(to_h)
        end

        def to_yaml(*_args)
            to_h.to_yaml
        end

        def load_answers(raw_answers)
            correct_answer = raw_answers.find { |a| a.start_with?('*') }
            correct_answer = correct_answer ? correct_answer[1..].strip : raw_answers.first.strip
            shuffled_answers = raw_answers.map { |a| a.start_with?('*') ? a[1..].strip : a }.shuffle
            letters = ('A'..'Z').to_a
            
            shuffled_answers.each_with_index do |answer, index|
                @question_answers[letters[index]] = answer
            end
            
            @question_correct_answer = letters[shuffled_answers.index(correct_answer)]
        end

        def find_answer_by_char(char)
            @question_answers[char]
        end
    end
end