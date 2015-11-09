desc "See which teams have completed the challenge"
task :score_board => :environment do
  puts "Teams having completed the challenge:"
  Post.includes(:votes).where(:votes => { :value => 1 }).each do |post|
    puts "- #{post.name}"
  end

  puts; puts "Tally of votes:"
  Post.all.sort_by(&:score).reverse.each do |post|
    puts "- #{post.name}: #{post.score}"
  end
end
