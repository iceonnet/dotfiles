function workon_cwd {
    # Credits to: Harry Marr ( https://hmarr.com/2010/jan/19/making-virtualenv-play-nice-with-git/ )
    cd $@ 2>/dev/null
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? = 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME=`basename "$PROJECT_ROOT"`
        PYTHON=python
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            . "$PROJECT_ROOT/.venv"
        else
            return
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon "$ENV_NAME"
            else
                echo "virtual environment for ${ENV_NAME} does not exist, creating..."
                mkvirtualenv -a $PROJECT_ROOT --python ${PYTHON} "$ENV_NAME" > /dev/null
                python --version

                echo "installing requirements.development.txt"
                [ ! -e requirements.development.txt ] && \
                    echo "-r requirements.txt" > requirements.development.txt

                touch requirements.txt requirements.development.txt
                pip install -r requirements.development.txt > /dev/null
            fi
            export CD_VIRTUAL_ENV="$ENV_NAME"
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

alias cd="workon_cwd"
