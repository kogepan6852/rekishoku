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

Category.create(:name => '菓子', :slug =>'tea', :type =>'ShopCategory')
Category.create(:name => '食事', :slug =>'meal', :type =>'ShopCategory')
Category.create(:name => 'コース', :slug =>'course', :type =>'ShopCategory')
Category.create(:name => 'WEB', :slug =>'online', :type =>'ShopCategory')

Category.create(:name => '文化人', :slug =>'cultural_figures', :type =>'PersonCategory')
Category.create(:name => '文豪', :slug =>'literary_master', :type =>'PersonCategory')
Category.create(:name => '武将', :slug =>'military_commander', :type =>'PersonCategory')
Category.create(:name => '貴族', :slug =>'aristocracy', :type =>'PersonCategory')

Category.create(:name => '特集', :slug =>'feature', :type =>'FeatureCategory')
Category.create(:name => 'ツアー', :slug =>'tour', :type =>'FeatureCategory')
Category.create(:name => 'イベント', :slug =>'event', :type =>'FeatureCategory')

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

Price.create(:id => '1', :min => '0', :max => '999')
Price.create(:id => '2', :min => '1000', :max => '1999')
Price.create(:id => '3', :min => '2000', :max => '2999')
Price.create(:id => '4', :min => '3000', :max => '3999')
Price.create(:id => '5', :min => '4000', :max => '4999')
Price.create(:id => '6', :min => '5000', :max => '5999')
Price.create(:id => '7', :min => '6000', :max => '7999')
Price.create(:id => '8', :min => '8000', :max => '9999')
Price.create(:id => '9', :min => '10000', :max => '14999')
Price.create(:id => '10', :min => '15000', :max => '19999')
Price.create(:id => '11', :min => '20000', :max => '29999')
Price.create(:id => '12', :min => '30000', :max => '49999')
Price.create(:id => '13', :min => '50000', :max => '999999')
