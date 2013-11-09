# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Type.create([{ name: 'image' }, { name: 'video' }, { name: 'text' }])

Category.create([{ name: 'funny', slug: 'funny' },
                 { name: 'cool', slug: 'cool' },
                 { name: 'cute', slug: 'cute' },
                 { name: 'weird', slug: 'weird' }])
