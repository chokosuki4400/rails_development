# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

email = ["sato","suzuki","takahashi","tanaka"]
names = ["佐藤", "鈴木", "高橋", "田中"]
images = ["https://c.okmusic.jp/news_items/images/252544/more_large.jpg?1521096697","https://www.pakutaso.com/assets_c/2015/03/kawamurayuka-thumb-600x600-12130.jpg","https://www.pakutaso.com/assets_c/2017/02/dandadebu-thumb-600x600-30435.jpg","https://www.pakutaso.com/assets_c/2017/11/model_max_ezaki-thumb-800x800-37240.jpg"]

0.upto(4) do |idx|
  User.create!(
    :email =>"#{email[idx]}@example.com",
    :password => "password",
    :encrypted_password => "password",
    :name => "#{names[idx]}",
    :nickname => "#{email[idx]}",
    :profile => "よくある#{names[idx]}です。",
    :image => "#{images[idx]}"
  )
end
