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
//$file_name  = strval($argv[2]);

// 读文件
$vz_buf = file_get_contents($bin_name);
if($vz_buf===FALSE) exit;

$vz_len = strlen($vz_buf);


//echo "in : $bin_name\n";
//echo "out : $file_name\n";

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
//printf("filename len : %d\n",$n);

$fn_len = ($n>=17)?17:$n+1;
$prg_len = $vz_len -4-17-1-2;
$mif_len = 2+1+128+5+1+$fn_len+2+2+$prg_len+2+20;
$cass_len =    128+5+1+$fn_len+2+2+$prg_len+2+20;


// VZF_TYPE
$i = 4+17;
$vzf_type = ord($vz_buf{$i});

// VZF_FILENAME
$i = 4;
$vzf_filename = "";
for($n=0;$n<$fn_len;$n=$n+1)
	$vzf_filename{$n} = $vz_buf{$i+$n};

// VZF_STARTADDR
$vzf_startaddr = 0;
$i = 4+17+1;
$vzf_startaddr = ord($vz_buf{$i+0});
$vzf_startaddr += ord($vz_buf{$i+1})*256;

// END ADDR
$vzf_endaddr = $vzf_endaddr + $prg_len -1;


// DATA
$i = 4+17+1+2;
$vzf_data = "";
for($n=0;$n<$prg_len;$n=$n+1)
{
	$vzf_data{$n} = $vz_buf{$i+$n};
}

$fn = $bin_name;
$file_basename = basename($fn);

$fn_b = basename($fn,".vz");
if($fn_b!=basename($fn))
	$file_basename = $fn_b;

$fn_b = basename($fn,".VZ");
if($fn_b!=basename($fn))
	$file_basename = $fn_b;


$file_name = sprintf("%s.%02X.%04X.bin",$file_basename,$vzf_type,$vzf_startaddr);

echo "$bin_name to $file_name\n";
echo "cass name $vzf_filename\n";
printf("start address %04X  end address %04X  len %04X(%d)",$vzf_startaddr, $vzf_endaddr, $prg_len, $prg_len);

//echo $s;
file_put_contents($file_name, $vzf_data);
