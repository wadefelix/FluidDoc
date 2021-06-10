#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

## 1 merge the pytorch to paddle api map tables
FILES_ARRAY=("https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/README.md"
"https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/ops/README.md"
"https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/nn/README.md"
"https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/loss/README.md"
"https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/utils/README.md"
"https://raw.githubusercontent.com/PaddlePaddle/X2Paddle/develop/docs/pytorch_project_convertor/API_docs/vision/README.md"
)
TARGET_FILE=${SCRIPT_DIR}/../../docs/guides/08_api_mapping/pytorch_api_mapping_cn.md
TMP_FILE=/tmp/merge_pytorch_to_paddle_maptables.tmp

echo -n > ${TARGET_FILE}
for f in ${FILES_ARRAY[@]} ; do
    echo -n > ${TMP_FILE}
    echo "downloading ${f} ..."
    curl_succ='false'
    for i in 1 2 3 4 5 ; do
      if [ "${https_proxy}" != "" ] ; then
        STATUS_CODE=$(curl -o ${TMP_FILE} -sILk -w "%{http_code}" -x ${https_proxy} ${f})
      else
        STATUS_CODE=$(curl -o ${TMP_FILE} -sILk -w "%{http_code}" ${f})
      fi
      if [ "${STATUS_CODE}" = "200" ] ; then
        curl_succ='true'
        break
      fi
    done
    if [ $curl_succ = 'false' ] ; then
      echo "download ${f} failed. STATUS_CODE=${STATUS_CODE}"
      #exit 1
    fi
    echo >> ${TMP_FILE}
    cat ${TMP_FILE} >> $TARGET_FILE
done

