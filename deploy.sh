gitRepo_path='/opt/soft/gitrepo/young-mannix'
# WEB_USER='root'
# WEB_USERGROUP='root'
web_page_path='/opt/soft/nginx/html'
back_up_path='/opt/soft/webhook/back_up'
build_path='/opt/soft/gitrepo/young-mannix/build'
nginx_path='/opt/soft/nginx/sbin'

echo "+++++++++++++++Start deployment++++++++++++++++"

function reload() {
    echo "+++++++++start reload+++++++++++"
    $nginx_path/nginx -s reload
    echo "nginx reload successful!!! just enjoy..."
    echo "+++++++++ end reload +++++++++++"
}


function replace() {
    echo "+++++++++start replace+++++++++++"
    cd $build_path
    cp 000.tar $web_page_path
    cd $web_page_path
    tar -xvf 000.tar ./
    rm -rf 000.tar
    echo "+++++++++ end replace +++++++++++"

    reload;
}

function backup() {
    echo "+++++++++start backup+++++++++++"
    cd $web_page_path
    bkdate=$(date +%s) # 备份日期
    tar -cvf $bkdate.tar.gz ./
    cp $bkdate.tar.gz $back_up_path
    rm -rf *
    echo "++++++++++ end backup+++++++++++"

    replace;
}

function build() {
    echo "+++++++++start building+++++++++++"
    npm i --unsafe-perm
    npm run build
    cd $build_path
    tar -cvf 000.tar ./
    echo "+++++++++building end ++++++++++++"

    backup;
}


function git_pull_code() {
    cd $gitRepo_path
    echo "==============pulling source code=============="
    git clean -ffdx
    git reset --hard
    git fetch
    git checkout master
    git pull
    echo "==============pulling code over================"

    build;
}
# chown -R $WEB_USER:$WEB_USERGROUP $gitRepo_path
git_pull_code;