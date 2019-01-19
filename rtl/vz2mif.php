<?php
//include_once('view.php');

function show_bit($ch)
{
	//for($i=128;$i>1;$i=$i/2)
	for($i=1;$i<256;$i=$i*2)
	{
		echo ($ch&$i)?"#":".";
	}
}

$bin_name  = strval($argv[1]);
$file_name  = strval($argv[2]);

// 读文件
$vz_buf = file_get_contents($bin_name);
if($vz_buf===FALSE) exit;

$vz_len = strlen($vz_buf);

echo "in : $bin_name\n";
echo "out : $file_name\n";

/*
for($i=0;$i<$l;$i++) {
	$ch = ord($buf{$i});
	show_bit($ch);
	printf("  %04X %02X\n", $i, $ch);
}
*/

$dat_sum=0;
//$dat_sum=0xFF00;


// VZF_MAGIC 0x20 0x20 0x00 0x00
// VZF_MAGIC 0x56 0x5a 0x46 0x30 VZF
if( !( (ord($vz_buf{0})==0x20 && ord($vz_buf{1})==0x20 && ord($vz_buf{2})==0x00 && ord($vz_buf{3})==0x00 ) ||
       (ord($vz_buf{0})==0x56 && ord($vz_buf{1})==0x5a && ord($vz_buf{2})==0x46 && ord($vz_buf{3})==0x30 )) ) {
	echo "err format\n";
	exit;
}

// len

$i = 4;
for($n=0;$n<17;$n=$n+1) {
	if($vz_buf{$i+$n}=="\0") break;
}
printf("filename len : %d\n",$n);

$fn_len = ($n>=17)?17:$n+1;
$prg_len = $vz_len -4-17-1-2;
$mif_len = 2+1+128+5+1+$fn_len+2+2+$prg_len+2+20;
$cass_len =    128+5+1+$fn_len+2+2+$prg_len+2+20;

printf("prg len : %d\n",$prg_len);
printf("mif len : %d\n",$mif_len);

$j = 0;
$buf{$j} = chr($cass_len&0xff);
//$buf{$j+1} = chr(intdiv($cass_len&0xff00,256));
$buf{$j+1} = chr(($cass_len>>8)&0xff);

// wait 0.003s
$j = 2;
$buf{$j} = chr((2+1+128+5+1+$fn_len)&0xff);

// cass sync head
$j = 2+1;
for($n=0;$n<128;$n=$n+1)
	$buf{$j+$n} = chr(0x80);

$j = 2+1+128;
for($n=0;$n<5;$n=$n+1)
	$buf{$j+$n} = chr(0xFE);

// VZF_TYPE
$i = 4+17;
$j = 2+1+128+5;
$buf{$j} = $vz_buf{$i};

// VZF_FILENAME
$i = 4;
$j = 2+1+128+5+1;
for($n=0;$n<$fn_len;$n=$n+1)
	$buf{$j+$n} = $vz_buf{$i+$n};

// VZF_STARTADDR
$i = 4+17+1;
$j = 2+1+128+5+1+$fn_len;
$buf{$j+0} = $vz_buf{$i+0};
$buf{$j+1} = $vz_buf{$i+1};

$prg_end = ord($vz_buf{$i+0}) + ord($vz_buf{$i+1})*256 + $prg_len;

//printf("START ADDR %04X  END ADDR %04X\n", ord($vz_buf{$i+0}) + ord($vz_buf{$i+1})*256, $prg_end);

// END ADDR
$buf{$j+2} = chr($prg_end&0xff);
//$buf{$j+3} = chr(intdiv($prg_end&0xff00,256));
$buf{$j+3} = chr(($prg_end>>8)&0xff);

$dat_sum += ord($buf{$j+0});
$dat_sum += ord($buf{$j+1});
$dat_sum += ord($buf{$j+2});
$dat_sum += ord($buf{$j+3});


// DATA
$i = 4+17+1+2;
$j = 2+1+128+5+1+$fn_len+2+2;

for($n=0;$n<$prg_len;$n=$n+1)
{
	$buf{$j+$n} = $vz_buf{$i+$n};
	$dat_sum += ord($buf{$j+$n});
}

$j = 2+1+128+5+1+$fn_len+2+2+$prg_len;

$buf{$j+0} = chr($dat_sum&0xff);
$buf{$j+1} = chr(($dat_sum>>8)&0xff);

// cass sync tail
$j = 2+1+128+5+1+$fn_len+2+2+$prg_len+2;
for($n=0;$n<20;$n=$n+1)
	$buf{$j+$n} = chr(0);


$s = "";
$s .= "DEPTH = $mif_len;\n";
$s .= "WIDTH = 8;\n";
$s .= "ADDRESS_RADIX = HEX;\n";
$s .= "DATA_RADIX = HEX;\n";
$s .= "CONTENT\n";

$s .= "BEGIN\n";
for($i=0;$i<$mif_len;$i++) {
	$ch = ord($buf{$i});
	$s .= sprintf("%04X:%02X;\n", $i, $ch);
}
$s .= "END;\n";
//echo $s;
file_put_contents($file_name,$s);
