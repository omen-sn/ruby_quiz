module Quiz
    class Statistics
        def initialize(writer)
            @correct_answers = 0
            @incorrect_answers = 0
            @writer = writer
        end
    
        def correct_answer
            @correct_answers += 1
        end
    
        def incorrect_answer
            @incorrect_answers += 1
        end
    
        def print_report
            total_questions = @correct_answers + @incorrect_answers
            correct_percentage = total_questions > 0 ? (@correct_answers.to_f / total_questions * 100).round(2) : 0
            
            report = "Підсумок тесту:\n"
            report += "Коректні відповіді: #{@correct_answers}\n"
            report += "Некоректні відповіді: #{@incorrect_answers}\n"
            report += "Загальна кількість запитань: #{total_questions}\n"
            report += "Процент коректних відповідей: #{correct_percentage}%\n"
            
            @writer.write(report)
        end
    end
end    