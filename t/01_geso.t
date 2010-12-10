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
    
    if ($block->match) {
        like($output, $block->match);
    } else {
        is($output, $block->expected);
    }
};

__DATA__
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


=== IKA/GESO: postp KA 名詞+
--- input:    お店か
--- expected: お店じゃなイカ
=== IKA/GESO: postp KA 名詞+
--- input:    お店かな
--- expected: お店じゃなイカな
=== IKA/GESO: postp KA 副詞+
--- input:    まだか
--- expected: まだでゲソか
=== IKA/GESO: postp KA 副詞+
--- input:    まだかな
--- expected: まだでゲソかな
=== IKA/GESO: postp KA 動詞+
--- input:    走るか？
--- expected: 走るかでゲソ？
=== IKA/GESO: postp KA 動詞+
--- input:    走るか？
--- expected: 走らなイカ？
--- SKIP


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
