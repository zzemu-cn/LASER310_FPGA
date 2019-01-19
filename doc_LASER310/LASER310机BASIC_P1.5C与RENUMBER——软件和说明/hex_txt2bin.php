<?php

function item_vals($filename)
{
	// 读取编辑的文件
	$a = array();
	if(file_exists($filename)) {
		$s = file_get_contents($filename);
		if(is_bool($s)) $s = "";

		$a = explode("\n",$s);
		if(!is_array($a)) $a = array();
	}

	return $a;
}

function split_char($c,$s)
{
	$v = explode($c,$s);
	$v = array_filter($v);
	return $v;
}

function split_sp($s)
{
	$v = preg_split('/:|-|\s/',$s);
	$v = array_filter($v);
	return $v;
}

// 检测字符 0--9 A--F a--f
function check_hex_char($hex)
{
	//echo $hex;
	for($i=0;$i<strlen($hex);$i++) {
		$ch = $hex{$i};
		if( !( ($ch>="0"&&$ch<="9") || ($ch>="A"&&$ch<="F") || ($ch>="a"&&$ch<="f") ) )
			return false;
	}
	return true;
}


function hex_txt2str($txtfile, $start_addr, $dbg=true)
{
	$lst = item_vals($txtfile);

	$buf="";

	$addr = $start_addr;
	foreach($lst as $line) {
		//echo trim($line);
		$hex_lst = split_sp(trim($line));
		foreach($hex_lst as $idx => $hex) {
			// 检测字符 0--9 A--F a--f
			if( !check_hex_char($hex) ) {
				echo "format err $line";
				exit(1);
			}
			// 检测地址
			if($idx==0) {
				if($addr!=hexdec($hex)) {
					printf("format err : %s %X", $hex, hexdec($hex));
					return "";
				}
				if($dbg)	printf("%X :", $addr);
				continue;
			}
			if(strlen($hex)>2 || strlen($hex)==0) {
				printf("format err : %s %X", $hex, hexdec($hex));
				return "";
			}
			if($dbg)	printf(" %02X", hexdec($hex));
			$buf .= hex2bin($hex);
			$addr++;
		}
		printf("\n");
	}

	return $buf;
}

// LASER_BASIC_P1.5C

$hex_txtfile = "LASER_BASIC_P1.5C.txt";
$cass_addr = 0x7B04;
$cass_name = "P1.5C";
$fn_vz = "BASIC_P1.5C.vz";
$fn_bin = "BASIC_P1.5C.7B04.bin";

$buf = hex_txt2str($hex_txtfile, $cass_addr);
if(!$buf) {
	printf("buf err %s\n",$hex_txtfile);
	exit(0);
}

//printf("start addr %02X %02X", $cass_addr&0xFF, ($cass_addr>>8)&0xFF);
printf("out file name  %s\n", $fn_vz);
printf("start addr %X\n", $cass_addr);
printf("bin len %X (%d)\n", strlen($buf), strlen($buf));

$vz_magic = "VZF0";
$vz_filename = $cass_name;
while(strlen($vz_filename)<17) {
	$vz_filename .= "\0";
}
$vz_type = "\xF1";
$vz_startaddr = chr($cass_addr&0xFF) . chr(($cass_addr>>8)&0xFF);

file_put_contents($fn_vz, $vz_magic.$vz_filename.$vz_type.$vz_startaddr.$buf);

file_put_contents($fn_bin, $buf);


	
printf("\n\n");

// LASER_RENUMBER

$hex_txtfile = "LASER_RENUMBER.txt";
$cass_addr = 0x74D3;
$cass_name = "RENUMBER";
$fn_vz = "RENUMBER.vz";
$fn_bin = "RENUMBER.74D3.bin";

$buf = hex_txt2str($hex_txtfile, $cass_addr);
if(!$buf) {
	printf("buf err %s\n",$hex_txtfile);
	exit(0);
}

//printf("start addr %02X %02X", $cass_addr&0xFF, ($cass_addr>>8)&0xFF);
printf("out file name  %s\n", $fn_vz);
printf("start addr %X\n", $cass_addr);
printf("bin len %X (%d)\n", strlen($buf), strlen($buf));

$vz_magic = "VZF0";
$vz_filename = $cass_name;
while(strlen($vz_filename)<17) {
	$vz_filename .= "\0";
}
$vz_type = "\xF1";
$vz_startaddr = chr($cass_addr&0xFF) . chr(($cass_addr>>8)&0xFF);

file_put_contents($fn_vz, $vz_magic.$vz_filename.$vz_type.$vz_startaddr.$buf);

file_put_contents($fn_bin, $buf);
