#!bin/bash
data=$(date "+%Y-%m-%d")
echo $datai
if [ ${1} ]
then
   msg="${1}-${data}"
else
   msg="update-${data}"
fi
git pull origin main
git config --global user.name "sunmeng"
git config --global user.email "1241577140@qq.com"
git add .
git commit -m "${msg}"
git push 