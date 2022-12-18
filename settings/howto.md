# ハウツー

https://texwiki.texjp.org/?LaTeX%20%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8

だいたいここにある。

## mintedでoutputdirを指定する

`\usepackage[section, outputdir=\detokenize{./dvi}]{minted}`これ。usepackageするときにdirを指定すること。

## 画像が出ない && dvipdfmx:warning: Unparsed material at end of special ignored.

`\usepackage[dvipdfmx]{graphicx}`が原因。documentclassのオプションとして指定してすべてのパッケージに読ませる。`\documentclass[indiv, dvipdfmx]{jikken}`例えばこう。

## キャプション付きがページの最初に強制的に配置される

`\usepackage{float}`して

```
 \begin{figure}[H]
     \centering
     \includegraphics[width=5cm]{Lenna.png}
     \caption{Lenna.png}
 \end{figure}
```

こう。`\begin{figure}[H]`のように`[H]`を付ける。

## mintinlineの怒られ

mintinlineは言語を指定しないと怒られる。ファイル名とか置くだけでも。
`\mintinline{bash}{python3 kiso.py}`

追記:言語指定が誤字ってても怒られる。

## mintedでオプションを先に書いておく

```
\newminted[myMinted]{octave}{
    linenos,
    breaklines,
    mathescape,
    numbersep=5pt,
    frame=lines,
    framesep=2mm
}
\newmintedfile[myMintedfile]{octave}{
    linenos,
    breaklines,
    mathescape,
    numbersep=5pt,
    frame=lines,
    framesep=2mm
}

```

こうして`\myMintedfile{digital/06.m}`こんな感じで書き込むとそこに埋め込んでくれる。

## Cannot determine size of graphic in 画像 (no BoundingBox).

これはbb情報がないのが原因。

`extractbb -O digital/06gurahu.png`とかで

```
root@c6d19c9b0e32:/workspaces/latexenv# extractbb -O digital/06gurahu.png
%%Title: digital/06gurahu.png
%%Creator: extractbb 20210318
%%BoundingBox: 0 0 1029 768
%%HiResBoundingBox: 0.000000 0.000000 1029.000000 768.000000
%%CreationDate: Mon Nov 15 14:07:37 2021
```

の`HiResBoundingBox`を抜いてきて`\includegraphics[bb=0.000000 0.000000 1029.000000 768.000000, width=15cm]{digital/06gurahu.png}`とでもすればよいが面倒。
しかも自動実行されるはずだがされていない。

これは`\usepackage{graphicx}`が原因。`\usepackage[dvipdfmx]{graphicx}`にしてあげると動く。てかdocumentclassで指定しろ。

## ヘッダーフッター

```
\newcommand{\me}{{まるまるまるまる　第06回課題 \hfil 名前}}

\makeatletter
\def\@oddhead{\me}% 奇数ページのフッターの中央にハイフンで挟んだノンブルを記載
\def\@evenhead{\me}% 奇数ページのフッターの中央にハイフンで挟んだノンブルを記載
\makeatother
```

こんな感じ、`\thepage`とかもある。ぐぐること。

## myminted環境とかでlatexindentが自動整形して辛い

追記
https://gist.github.com/Yarakashi-Kikohshi/8c39707f83ba73b3bce73c54638ac594

こっちの方がよさそう。

追記ここまで

https://qiita.com/3rdJCG/items/0e70cdcc03080d9b93f6

これ。

```
\begin{myMinted}
    Conv2D(64, kernel_size=(3, 3), activation="relu", input_shape=input_shape),
\end{myMinted}
```

```
\begin{myMinted}
Conv2D(64, kernel_size=(3, 3), activation="relu", input_shape=input_shape),
\end{myMinted}
```

下のにしたい時は、自分でインデントの設定をいじれば良い。

どこかしらでlatexindent.plを実行すると`indent.log`みたいなのが吐き出される。これにdefaultSettings.yamlがどこにあるかが書いてあるので見つけて編集。Dockerfileに書き足すべき。
見つけたら
```yaml
indentRules:
   myenvironment: "\t\t"
   anotherenvironment: "\t\t\t\t"
   chapter: " "
   section: " "
   item: "      "
   myitem: "        "
   myMinted: ""
```
こんな感じにしてやればおっけー。
他のもいじれる。

## Runaway argumentとか言われるけどミスってない .auxの中身が途中までしか生成されてない

aux, log, dviを消して再生成させる。なんか動いた。わかんね。


## mintedのスタイル参考

https://tex.stackexchange.com/questions/103141/set-global-options-for-inputminted

これよさそう。

## circuitikzで抵抗の中に配線がめり込む

標準のscale（＝描画サイズ？）がでかいので小さくすると良い。

`\ctikzset{resistors/scale=0.8, capacitors/scale=0.7}`でいい感じに。インダクタは意外とでかいからそのままで良い。

```
\begin{figure}[H]
    \begin{center}
        \begin{circuitikz}[american currents]
            \ctikzset{resistors/scale=0.8, capacitors/scale=0.7} % here!
            \draw
            (0,2) node[anchor=east]{}
            to[normal closed switch, o-] ++(1,0)
            to[generic=R] ++(1,0)
            to[short, -*, i=$i(t)$] ++(1,0)
            to[L=L, -*] ++(0,-2)
            to[short, -]++(-1,0)
            to[short, -, i=$i(t)$] ++(-1,0)
            to[short, -o]++(-1,0)

            (3,2)
            to[short, -o] ++(1,0)

            (3,0)
            to[short, -o] ++(1, 0)

            (0,0)
            to[open, v^=$v_I$]++(0,2)

            (4,0)
            to[open, v=$v_L$]++(0,2)
            ;
        \end{circuitikz}
        \caption{RL直列回路}
        \label{fig:RL}
    \end{center}
\end{figure}
```

## hyperrefに"Token not allowed in a PDF string (Unicode)"って怒られる

PDF上でのメタデータでは数式を保持できないので怒られる。

https://blog.miz-ar.info/2015/09/latex-hyperref-tips-2/

```
\subsection{\texorpdfstring{$t = 0, v_C(t) = 0$}{t = 0, v\_C(t) = 0}の時}
```

こんな感じでtexorpdfstringで囲ってあげると消える。手前がtex表記、後ろがpdf用。
