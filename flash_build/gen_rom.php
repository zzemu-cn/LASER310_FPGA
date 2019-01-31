<?php
//include_once('view.php');

//$bin_name  = strval($argv[1]);
//$file_name  = strval($argv[2]);

$file_name  = "flash_rom.bin";

$rom_lst	=	[
	//	bank 0
	[	"vtech/vtechv20.u12",			0,	],	// 16K
	[	"vtech/vtechv12.u12",			1,	],	// 16K
	[	"vtech/vtechv21.u12",			2,	],	// 16K

	[	"vtech/vzdosv12.rom",			8,	],	// 8K
	[	"vtech/char.rom", 				9,	],	// 8K

	//	bank 16
	[	"vz/BUST OUT.vz",				16,	],	//
	[	"vz/COS-RES.VZ", 				17,	],	//
	[	"vz/CRASH.VZ",					18,	],	//
	[	"vz/DAWN.VZ", 					19,	],	//
	[	"vz/HOPPY.VZ",					20,	],	//
	[	"vz/KAMIKAZE.VZ", 				21,	],	//
	[	"vz/P-CURSE3.VZ",				22,	],	//
	[	"vz/MONITORR.vz", 				23,	],	//
	[	"vz/PUCK MAN.vz",				24,	],	//
	[	"vz/Space_Ram.vz", 				25,	],	//

	//	bank 32 48
	[	"CEC-I/MX231024-0059.bin",				32,	],	// 128K CEC-I 国标GB2312字库 16 x 16 点阵
	[	"CEC-I/MX231024-0060.bin", 				40,	],	// 128K 
	[	"CEC-I/U7.TMM24256AP.bin",				48,	],	// 32K
	[	"CEC-I/U35.TMM24256AP.bin", 			50,	],	// 32K
	[	"CEC-I/U13.9433C-0202.RCL-ZH-32.bin", 	52,	],	// 4K 字符点阵字模 8 x 8 点阵

	//	bank 64 80
	[	"CEC-E/u4.c3001.531000.bin",			64,	],	// 128K CEC-E 国标GB2312字库 16 x 16 点阵
	[	"CEC-E/u7.c3002.531000.bin", 			72,	],	// 128K 
	[	"CEC-E/u14.rom20.27256.bin",			80,	],	// 32K
	[	"CEC-E/u20.rom10.27256.bin", 			82,	],	// 32K
	[	"CEC-E/u13.9433c-0202.rcl-zh-32.bin", 	84,	],	// 4K 字符点阵字模 8 x 8 点阵

	// bank 96
];

$bin_buf = str_repeat("\x00", 96*1024*16);
//echo strlen($bin_buf);
// 读文件

foreach($rom_lst as $item)
{
	$fn = $item[0];
	$pos = $item[1]*16*1024;

	//echo "in : $fn\n";

	$rom_buf = file_get_contents($fn);
	if($rom_buf===FALSE) exit;
	$rom_len = strlen($rom_buf);

	// 如果后缀是 .vz 需要再开头写入文件长度
	$file_basename = basename($fn);

	$fn_b = basename($fn,".vz");
	if($fn_b != basename($fn))
		$file_basename = $fn_b;

	$fn_b = basename($fn,".VZ");
	if($fn_b != basename($fn))
		$file_basename = $fn_b;


	echo "in : $fn  pos $pos  len $rom_len\n";

	$off=0;

	if( $file_basename != basename($fn) ) {
		echo "VZF fomat $fn\n";
		$bin_buf{$pos+0} = chr($rom_len&0xFF);
		$bin_buf{$pos+1} = chr(($rom_len>>8)&0xFF);
		$off=2;
	}

	for($i=0;$i<$rom_len;$i++) {
		$bin_buf{$i+$off+$pos} = $rom_buf{$i};
	}

	//$n = $pos+2;
	//printf( "%08X %02X", $n, ord($bin_buf{$n}) );
}

echo "out : $file_name\n";

//$n = 0x40002;
//printf( "%08X %02X", $n, ord($bin_buf{$n}) );

file_put_contents($file_name,$bin_buf);
