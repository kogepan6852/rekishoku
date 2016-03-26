task :site_map do
    #site mapを更新する
    exec "rake sitemap:refresh"
end
