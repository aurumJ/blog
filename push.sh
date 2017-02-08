#! /bin/bash
# 保存当前目录
currentDir=$PWD
echo "Start Pull Blog...."
cd d:/blog
git pull origin master
echo "Start Push Blog...."
git add .
git commit -m "Blog Change Backup"
git push origin master
echo "Start Generate Blog"
hexo g -d
cd $currentDir
echo "Success";
