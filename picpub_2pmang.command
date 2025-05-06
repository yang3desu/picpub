#!/bin/bash

# ---------------------------------
# picpub.command
# jpgを形式変換し、元ファイル、原寸png、縮小pngの3つのファイルにする。
# ※画像のファイル容量によっては処理に時間がかかります。

# ---------------------------------
# 動作環境: macOS Monterey 12.1
# 要 ImageMagick(homebrew)

# このファイルをjpgファイルが存在するディレクトリに置きます。
# ダブルクリックすると、同階層に存在するjpgを原寸pngに形式変換します。
# その後、原寸pngをリサイズし、縦横比を維持したまま長辺1024pixelに縮小します。

# ※000.jpgがあるときは、2ページに分割する

# 001.jpg（元ファイル）
# 001.png（原寸png）
# 101.png（縮小png）

# ※シェルスクリプトの仕様上、ファイルに半角スペースが含まれる場合めんどくさ……ちゃんと動かないので、その画像ファイルは無視します。
# ※画像は99枚まで。100画像を超すコンテンツは読者の集中力の限界を見誤ってるのでちゃんと取捨選択するか分割しましょう。
# 使うときはchmodで実行権限を与えてください。

# ---------------------------------

# このcommandファイルが置かれている場所に移動
cd `dirname $0`
echo `pwd`
echo "---------------------------------"


# ファイル数が多すぎる場合一応エラーを出す
count=$(find ./ -maxdepth 1 -name '*.jpg' | wc -l)
if [ ${count} -ge 100 ]; then
    echo "ファイルの数が多すぎます。99枚までにしてください"
    exit
fi

if [ -f 000.jpg ]; then
    echo "000.jpgを２ページに分割 -> 001.jpg,002.jpg"
    convert 000.jpg -crop 3680x5350+5100+430 001.jpg
    convert 000.jpg -crop 3680x5350+380+430 002.jpg
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

        # 000は飛ばす
        if [ $suji = "000" ]; then
            continue
        fi

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

        # Jpgはいらないので消す
        echo "削除 ${file}"
        rm $file
    fi

    # 次のループの前にsujiを初期化しておく
    suji="$null"
done






echo "---------------------------------"

<< "#__CO__"


Ver 0.2 000.jpgを２ページに分割する機能追加 2022/08/27
Ver 0.1 リリース

機能追加要望
・サムネイルを作成するため、AffinityPhotoのテンプレートファイルをコピーしてリネームするところまで組み込みたい

#__CO__
