pipeline {
    agent any
    tools{
        jdk 'jdk-17'
    }

    environment {
        PROJECT_CONFIG = '.project-config.yaml'
        scannerHome = tool 'Rikkei SonarQube'
        flutterSDKCacheDirectory = '/Users/servermac-d1-m/fvm/versions'
    }

   options {
      gitLabConnection('Rikkei GitLab')
      gitlabBuilds(builds: ['SonarScanner'])
   }

    stages {
        stage('Check Flutter SDK') {
            steps {
                script {
                    updateGitlabCommitStatus name: 'SonarScanner', state: 'pending'

                    def projectConfigProps = readProperties file: "${PROJECT_CONFIG}"
                    FLUTTER_VERSION = projectConfigProps['flutter_version']
                    env.JAVA_VERSION = projectConfigProps['java_version']
                    env.FLUTTER_VERSION = FLUTTER_VERSION
                    def OS_TYPE = sh(script: 'uname -s', returnStdout: true).trim()
                    def folderExists = false
                    def flutterSDKFile
                    if (OS_TYPE == 'Linux' || OS_TYPE == 'Darwin') {
                        TARGET_FOLDER = "${flutterSDKCacheDirectory}/${FLUTTER_VERSION}"
                        // Linux (including Ubuntu) or macOS
                        def checkCommand = "test -d ${TARGET_FOLDER} && echo 'true' || echo 'false'"
                        folderExists = sh(script: checkCommand, returnStdout: true).trim() == 'true'
                    } else {
                        error "Unsupported operating system: ${OS_TYPE}"
                    }

                    if (folderExists) {
                        echo "Folder '${TARGET_FOLDER}' exists."
                    } else {
                        echo "Folder '${TARGET_FOLDER}' does not exist."

                        echo 'Downloading Flutter SDK...'
                        def downloadUrl
                        if (OS_TYPE == 'Linux') {
                            flutterSDKFile = "flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
                            downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${flutterSDKFile}"
                        } else if (OS_TYPE == 'Darwin') {
                            flutterSDKFile = "flutter_macos_${FLUTTER_VERSION}-stable.zip"
                            downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/${flutterSDKFile}"
                        } else {
                            error "Unsupported operating system: ${OS_TYPE}"
                        }
                        echo 'Check SDK was downloaded'

                        def exists = fileExists "${flutterSDKFile}"

                        if (exists) {
                            echo "Yes, ${flutterSDKFile} exists."
                        } else {
                            echo "No, ${flutterSDKFile} does not exist."
                            sh "curl -O ${downloadUrl}"

                        }

                        echo 'Extracting Flutter SDK.....'
                        sh 'mkdir -p ${flutterSDKCacheDirectory}/'
                        if (OS_TYPE == 'Linux') {
                            sh "apt-get install xz-utils"
                            sh "tar xf ${flutterSDKFile}"
                        } else if (OS_TYPE == 'Darwin') {
                            sh "unzip -q ${flutterSDKFile} -d ./"
                        }
                        // Rename extracted flutter directory to $FLUTTER_VERSION
                        sh "mv ./flutter ${flutterSDKCacheDirectory}/${FLUTTER_VERSION}"
                    }
                    // Get Absolute path of Flutter SDK
                    def flutterSdkDirCommand = "echo ${flutterSDKCacheDirectory}/${FLUTTER_VERSION}/bin"
                    env.FLUTTER_SDK_DIR = sh(script: flutterSdkDirCommand, returnStdout: true).trim()
                    sh "git config --global --add safe.directory ${flutterSDKCacheDirectory}/${FLUTTER_VERSION}"

                    env.PATH = "${env.FLUTTER_SDK_DIR}:${env.PATH}"
                }
            }
        }
        stage('Flutter Generate') {
            steps {
                script {
                    echo 'Running Flutter Generate'
                    sh 'flutter clean'
                    sh 'flutter pub get'
                    sh 'flutter pub run build_runner build --delete-conflicting-outputs'
                }
            }
        }
        stage('SonarScanner') {
            steps {
                updateGitlabCommitStatus name: 'SonarScanner', state: 'running'
                script {
                    echo "Workspace: ${WORKSPACE}"
                    try {
                        withSonarQubeEnv(installationName: 'Rikkei SonarQube') {
                            echo 'Running SonarQube analysis'
                            sh '${scannerHome}/bin/sonar-scanner'
                        }
                    } catch (e) {
                        echo "Error: ${e}"
                        updateGitlabCommitStatus name: 'SonarScanner', state: 'canceled'
                    }

                }

            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate(abortPipeline: true)
                        if (qg.status != 'OK') {
                            updateGitlabCommitStatus name: 'SonarScanner', state: 'failed'
                        } else {
                            updateGitlabCommitStatus name: 'SonarScanner', state: 'success'
                        }
                    }
                }
            }
            post {
                success {
                    script {
                        def taskInfo = readProperties file: '.scannerwork/report-task.txt'
                        def dashboardUrl = taskInfo['dashboardUrl']
                        addGitLabMRComment(comment: "Results of Jenkins build available at: <a href='${BUILD_URL}'>${BUILD_URL}</a><br />The SonarQube analyze completed, you can find the results at: <a href='${dashboardUrl}'>${dashboardUrl}</a>")
                    }
                }
            }
        }
    }




    post {
        always {
            echo 'Pipeline finished!!'
        }

        success {
            echo 'Pipeline succeeded!'

        }

        failure {
            echo 'Pipeline failed!'

        }

        aborted {
            echo 'Pipeline aborted!'
        }
    }
}
