#!/bin/bash

# ---------------------------------
# picpub.command
# jpgを形式変換し、元ファイル、原寸png、縮小pngの3つのファイルにする。
# ※画像のファイル容量によっては処理に時間がかかります。

# ---------------------------------
# 動作環境: macOS Monterey 12.1
# 要 ImageMagick

# このファイルをjpgファイルが存在するディレクトリに置きます。
# ダブルクリックすると、同階層に存在するjpgを原寸pngに形式変換します。
# その後、原寸pngをリサイズし、縦横比を維持したまま長辺1024pixelに縮小します。

# 001.jpg（元ファイル）
# 001.png（原寸png）
# 101.png（縮小png）

# ※シェルスクリプトの仕様上、ファイルに半角スペースが含まれる場合めんどくさ……ちゃんと動かないので、その画像ファイルは無視します。
# ※画像は99枚まで。100画像を超すコンテンツは読者の集中力の限界を見誤ってるのでちゃんと取捨選択するか分割してください。
# 必要に応じてchmodで実行権限を与えてください。

# ---------------------------------

# このcommandファイルが置かれている場所に移動
cd `dirname $0`
echo `pwd`
echo "---------------------------------"


# ファイル数が多すぎる場合一応エラーを出す
count=$(find ./ -maxdepth 1 -name '*.jpg' | wc -l)
if [ ${count} -ge 100 ]; then
    echo "jpgファイルの数が多すぎます。同階層99枚までにしてください"
    exit
fi

# jpgファイルの数だけforをまわす
for file in `ls *.jpg`; do

    # 空白スペースとかがファイル名に入ってるとうまく動かないので無視
    if [ ! -f $file ]; then
        echo "ファイル名エラー。未処理 : ${file}"
        continue
    fi

    # ファイル名に含まれる「数の文字列」を変数sujiに入れる
    suji=`echo ${file} | sed -e 's/[^0-9]//g'`

    # sujiがセットされてる場合のみ以下↓を実行
    if [ $suji ]; then

        # 100を足し、100番台を用意
        hyakusuji="$(expr $suji + 100)"

        # sujiをゼロ埋めし、ファイル名000番台を用意
        suji=$(seq -f '%03g' ${suji} ${suji})
        
        # 拡張子をつける
        suji=`echo ${suji}.png`
        hyakusuji=`echo ${hyakusuji}.png`
       
        # ImageMagickで、画像を変換
        echo "${file} -> ${suji} & ${hyakusuji}"
        convert ${file} ${suji} # 原寸pngファイル
        convert ${suji} -resize 1024x1024 ${hyakusuji} # 縮小pngファイル
    fi

    # 次のループの前にsujiを初期化しておく
    suji="$null"
done

echo "---------------------------------"



<< "#__CO__"

Ver 0.11 エラー処理
Ver 0.10 リリース

#__CO__
