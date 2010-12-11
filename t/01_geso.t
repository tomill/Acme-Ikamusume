use strict;
use warnings;
use Test::Base;
plan tests => 1 * blocks;

use utf8;
binmode Test::More->builder->$_ => ':utf8'
    for qw(output failure_output todo_output);

use Acme::Ikamusume;

filters { match => 'regexp' };

run {
    my $block = shift;
    
    my $output = Acme::Ikamusume->geso($block->input);
    my $title = $block->name ."\n       input:  ". $block->input;
    
    if ($block->match) {
        like($output, $block->match, $title);
    } else {
        is($output, $block->expected, $title);
    }
};

__DATA__
=== SYNOPSIS
--- input:    イカ娘です。perlで侵略しませんか？
--- expected: イカ娘でゲソ。perlで侵略しなイカ？


=== IKA: replace
--- input:    以下のように
--- expected: イカのように
=== IKA: replace
--- input:    海からの使者、イカ娘でゲソ
--- expected: 海からの使者、イカ娘でゲソ
=== IKA: replace
--- input:    西瓜が一つ
--- expected: すイカが一つ
=== IKA: replace
--- input:    ハイカラな
--- expected: はイカらな
=== IKA: replace
--- input:    侵略しないか。
--- expected: 侵略しなイカ。
=== IKA: replace
--- input:    侵略じゃないか。
--- expected: 侵略じゃなイカ。
=== IKA: replace
--- input:    侵略しないかと
--- expected: 侵略しなイカと


=== GESO: userdic
--- input:    イカ娘です。
--- expected: イカ娘でゲソ。
=== GESO: userdic
--- input:    イカ娘ですから、
--- expected: イカ娘でゲソから、
=== IKA: userdic
--- input:    イカ娘ですか？
--- expected: イカ娘じゃなイカ？
=== IKA: userdic
--- input:    イカ娘ですね。
--- expected: イカ娘じゃなイカ。
=== IKA: userdic
--- input:    イカ娘ですよね。
--- expected: イカ娘じゃなイカ。
=== IKA: usedic
--- input:    イカ娘でしょうか？
--- expected: イカ娘じゃなイカ？


=== GESO: userdic
--- input:    イカ娘だ
--- expected: イカ娘でゲソ
=== GESO: userdic
--- input:    イカ娘だから
--- expected: イカ娘でゲソから
=== GESO: userdic
--- input:    イカ娘だが、
--- expected: イカ娘でゲソが、
=== IKA: userdic
--- input:    イカ娘だね
--- expected: イカ娘じゃなイカ
=== IKA: userdic
--- input:    イカ娘だよね
--- expected: イカ娘じゃなイカ
=== IKA: userdic (+ IKA replace)
--- input:    イカ娘だろうか。
--- expected: イカ娘じゃなイカ。


=== GESO: userdic
--- input:    イカ娘である
--- expected: イカ娘でゲソ
=== GESO: userdic
--- input:    イカ娘であるが、
--- expected: イカ娘でゲソが、
=== GESO: userdic
--- input:    イカ娘で、あるが、
--- expected: イカ娘で、あるが、
=== IKA: userdic
--- input:    そうかな。
--- expected: そうじゃなイカ。
=== IKA: userdic
--- input:    そうかなと。
--- expected: そうじゃなイカと。


=== IKA/GESO: postp KA 名詞+
--- input:    お店か
--- expected: お店じゃなイカ
=== IKA/GESO: postp KA 副詞+
--- input:    まだか
--- expected: まだでゲソか
=== IKA/GESO: postp KA 動詞+
--- input:    走るか？
--- expected: 走るかでゲソ？
=== IKA/GESO: postp KA 動詞+
--- input:    走るか？
--- expected: 走らなイカ？
--- SKIP


=== IKA: inflection 五段
--- input:    歩きませんか？
--- expected: 歩かなイカ？
=== IKA: inflection 五段
--- input:    泳ぎませんか？
--- expected: 泳がなイカ？
=== IKA: inflection 五段
--- input:    探しませんか？
--- expected: 探さなイカ？
=== IKA: inflection 五段
--- input:    勝ちませんか？
--- expected: 勝たなイカ？
=== IKA: inflection 五段
--- input:    死にませんか？
--- expected: 死ななイカ？
=== IKA: inflection 五段
--- input:    遊びませんか？
--- expected: 遊ばなイカ？
=== IKA: inflection 五段
--- input:    知りませんか？
--- expected: 知らなイカ？
=== IKA: inflection 五段
--- input:    笑いませんか？
--- expected: 笑わなイカ？

=== IKA: inflection 上一段
--- input:    いませんか？
--- expected: いなイカ？
=== IKA: inflection 上一段
--- input:    起きませんか？
--- expected: 起きなイカ？
=== IKA: inflection 上一段
--- input:    すぎませんか？
--- expected: すぎなイカ？
=== IKA: inflection 上一段
--- input:    閉じませんか？
--- expected: 閉じなイカ？
=== IKA: inflection 上一段
--- input:    落ちませんか？
--- expected: 落ちなイカ？
=== IKA: inflection 上一段
--- input:    浴びませんか？
--- expected: 浴びなイカ？
=== IKA: inflection 上一段
--- input:    しみませんか？
--- expected: しみなイカ？
=== IKA: inflection 上一段
--- input:    ふりませんか？
--- expected: ふらなイカ？

=== IKA: inflection 下一段
--- input:    見えませんか？
--- expected: 見えなイカ？
=== IKA: inflection 下一段
--- input:    受けませんか？
--- expected: 受けなイカ？
=== IKA: inflection 下一段
--- input:    告げませんか？
--- expected: 告げなイカ？
=== IKA: inflection 下一段
--- input:    見せませんか？
--- expected: 見せなイカ？
=== IKA: inflection 下一段
--- input:    混ぜませんか？
--- expected: 混ぜなイカ？
=== IKA: inflection 下一段
--- input:    捨てませんか？
--- expected: 捨てなイカ？
=== IKA: inflection 下一段
--- input:    茹でませんか？
--- expected: 茹でなイカ？
=== IKA: inflection 下一段
--- input:    寝ませんか？
--- expected: 寝なイカ？
=== IKA: inflection 下一段
--- input:    経ませんか？
--- expected: 経なイカ？
=== IKA: inflection 下一段
--- input:    食べませんか？
--- expected: 食べなイカ？
=== IKA: inflection 下一段
--- input:    求めませんか？
--- expected: 求めなイカ？
=== IKA: inflection 下一段
--- input:    入れませんか？
--- expected: 入れなイカ？

=== IKA: inflection カ変
--- input:    来ませんか？
--- expected: 来なイカ？
=== IKA: inflection サ変
--- input:    しませんか？
--- expected: しなイカ？


=== IKA: inflection ましょう
--- input:    しましょう！
--- expected: しなイカ！
=== IKA: inflection ましょうよ
--- input:    しましょうよ！
--- expected: しなイカ！


=== GESO: eos
--- input:    わかった。
--- expected: わかったでゲソ。
=== GESO: eos
--- input:    わかったでゲソ。
--- expected: わかったでゲソ。
=== GESO: eos
--- input:    いいじゃなイカ。
--- expected: いいじゃなイカ。
=== GESO: eos
--- input:    今日は、いい天気。
--- expected: 今日は、いい天気でゲソ。
=== GESO: eos
--- input:    なんと？　あああ　びっくり！
--- expected: なんとでゲソ？　あああ　びっくりでゲソ！


=== EBI: accent
--- input: 海老蔵が入院した
--- match: 海老.+蔵が入院した
=== EBI: accent
--- input: えびな市
--- match: えび.+な市
=== EBI: accent
--- input: 今日はエビフライ
--- match: 今日はエビ.+フライ


=== formal MASU to casual 五段
--- input:    今やります。
--- expected: 今やるでゲソ。
=== formal MASU to casual 上一段
--- input:    います。
--- expected: いるでゲソ。
=== formal MASU to casual 下一段
--- input:    見えます。
--- expected: 見えるでゲソ。
=== formal MASU to casual カ変
--- input:    来ます。
--- expected: 来るでゲソ。
=== formal MASU to casual サ変
--- input:    します。
--- expected: するでゲソ。


=== userdic: お主
--- input:    あなたは
--- expected: お主は
=== userdic: お主
--- input:    あんたは
--- expected: お主は
=== userdic: お主
--- input:    貴方は
--- expected: お主は
=== userdic: お主
--- input:    お前は
--- expected: お主は
=== userdic: お主
--- input:    おまえは
--- expected: お主は
=== userdic: お主
--- input:    そちは
--- expected: お主は
=== userdic: お主
--- input:    君は
--- expected: お主は
=== userdic: お主
--- input:    キミは
--- expected: お主は
=== userdic: お主
--- input:    きみは
--- expected: お主は
