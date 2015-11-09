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

Period.create(:name => '古墳時代以前')
Period.create(:name => '飛鳥時代')
Period.create(:name => '奈良時代')
Period.create(:name => '平安時代')
Period.create(:name => '鎌倉時代')
Period.create(:name => '南北朝時代')
Period.create(:name => '室町時代')
Period.create(:name => '戦国時代')
Period.create(:name => '安土桃山時代')
Period.create(:name => '江戸時代')
Period.create(:name => '明治時代')
Period.create(:name => '大正時代')
