# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(username: 'registered_user1', password: '111', access_level: User.access_levels[:registred])
user2 = User.create(username: 'registered_user2', password: '222', access_level: User.access_levels[:registred])
user3 = User.create(username: 'admin_user1', password: '111', access_level: User.access_levels[:admin])
user4 = User.create(username: 'admin_user2', password: '222', access_level: User.access_levels[:admin])

blog1 = Blog.create(name: 'registered_user1 news', user_id: user1.id, is_private: false)
blog2 = Blog.create(name: 'registered_user2 olds', user_id: user2.id, is_private: true)
blog3 = Blog.create(name: 'registered_user2 olds', user_id: user3.id, is_private: false)
blog4 = Blog.create(name: 'registered_user2 olds', user_id: user4.id, is_private: true)

Post.create(title: 'registered_user1 blog1 post1', blog_id: blog1.id, user_id: user1.id)
Post.create(title: 'registered_user2 blog1 post2', blog_id: blog1.id, user_id: user2.id)
Post.create(title: 'admin_user1 blog1 post3', blog_id: blog1.id, user_id: user3.id)
Post.create(title: 'admin_user2 blog1 post4', blog_id: blog1.id, user_id: user4.id)

Post.create(title: 'registered_user1 blog2 post1', blog_id: blog2.id, user_id: user1.id)
Post.create(title: 'registered_user2 blog2 post2', blog_id: blog2.id, user_id: user2.id)
Post.create(title: 'admin_user1 blog2 post3', blog_id: blog2.id, user_id: user3.id)
Post.create(title: 'admin_user2 blog2 post4', blog_id: blog2.id, user_id: user4.id)

Post.create(title: 'registered_user1 blog3 post1', blog_id: blog3.id, user_id: user1.id)
Post.create(title: 'registered_user2 blog3 post2', blog_id: blog3.id, user_id: user2.id)
Post.create(title: 'admin_user1 blog3 post3', blog_id: blog3.id, user_id: user3.id)
Post.create(title: 'admin_user2 blog3 post4', blog_id: blog3.id, user_id: user4.id)

Post.create(title: 'registered_user1 blog4 post1', blog_id: blog4.id, user_id: user1.id)
Post.create(title: 'registered_user2 blog4 post2', blog_id: blog4.id, user_id: user2.id)
Post.create(title: 'admin_user1 blog4 post3', blog_id: blog4.id, user_id: user3.id)
Post.create(title: 'admin_user2 blog4 post4', blog_id: blog4.id, user_id: user4.id)
