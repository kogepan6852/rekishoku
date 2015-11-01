# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

Category.create(:name => '歴食エピソード', :slug =>'episode', :type =>'PostCategory')
Category.create(:name => '歴食体験', :slug =>'experience', :type =>'PostCategory')
Category.create(:name => '歴食ニュース', :slug =>'information', :type =>'PostCategory')

Category.create(:name => 'お茶', :slug =>'tea', :type =>'ShopCategory')
Category.create(:name => '食事', :slug =>'meal', :type =>'ShopCategory')
Category.create(:name => 'コース', :slug =>'course', :type =>'ShopCategory')
Category.create(:name => 'WEB', :slug =>'online', :type =>'ShopCategory')
