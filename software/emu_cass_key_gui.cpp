// g++ -o emu_cass_key_gui emu_cass_key_gui.cpp vz2cass.cpp UART.cpp -mwindows -lnana -lgdi32 -lcomdlg32 -IC:/MinGW/include -DNANA_FILESYSTEM_FORCE -DMINGW_HAS_SECURE_API -D_FILE_OFFSET_BITS=64

#include <nana/gui.hpp>
#include <nana/gui/widgets/menubar.hpp>
#include <nana/gui/widgets/textbox.hpp>
#include <nana/gui/place.hpp>
#include <nana/gui/msgbox.hpp>
#include <nana/gui/filebox.hpp>
#include <nana/gui/widgets/button.hpp>

#include <nana/gui/wvl.hpp>
#include <nana/gui/widgets/group.hpp>
#include <nana/gui/place.hpp>
#include <nana/gui/widgets/button.hpp>
#include <nana/gui/widgets/form.hpp>
#include <nana/gui/widgets/label.hpp>
#include <nana/gui/widgets/combox.hpp>

#include <thread>
#include <iostream>


#include <cstdint>
#include <cstring>

#include "upload_tool.cpp"


using namespace nana;

int main()
{

	//internationalization i18n;
	//i18n.set("OK", u8"确定");
	//i18n.set("Cancel", u8"取消");

	form fm{API::make_center(600,400)};
	fm.caption("LASER310 emulator cass upload program");
	//fm.bgcolor(colors::mint_cream);
	place plc(fm);

	// the most external widgets
	label  title   {fm,  "LASER310 emulator cass upload program"};
	group  ext_gr{fm,  "LASER310 <bold=true, color=blue>Group:</>", true };

	label  lbl_serial_n   {fm,  "serila_no"};

	combox com_no(fm, nana::rectangle ( 20, 3, 150, 30) );
	//com_no.caption(("COM1"));
	com_no.push_back("COM1");
	com_no.push_back("COM2");
	com_no.push_back("COM3");
	com_no.push_back("COM4");
	com_no.push_back("COM5");
	com_no.push_back("COM6");
	com_no.push_back("COM7");
	com_no.push_back("COM8");
	com_no.push_back("COM9");

	// http://nanapro.org/zh-cn/documentation/utilities/place.htm
	plc.div("vert gap=10 margin=5 <lab weight=30><all> ");
	plc["lab"]  << title ;
	plc["lab"]  << lbl_serial_n ;
	plc["lab"]  << com_no;
	plc["all"]  << ext_gr;

	// the external group contain:
	group grp_cassette {ext_gr,  ("Cassette <bold=true, color=0xff0000, font=\"Consolas\">Group:</>"), true };
	group grp_keyboard{ext_gr,  ("Keyboard <bold=true, color=0xff0000, font=\"Consolas\">Group:</>"), true};

	ext_gr.div("horizontal gap=3 margin=20  < <cass_field> | 70% <keyb_field>> ");
	ext_gr["cass_field"]  << grp_cassette;
	ext_gr["keyb_field"]  << grp_keyboard;

	// 模拟磁带 the cassette group
	group nested_cass(grp_cassette.handle());
	//grp_cassette.div("buttons vert gap=5 margin=3");
	grp_cassette.div( "<vertical margin=2 gap=2 <vert lab> | <btn_field> | <info_field> >");

	button btn_upload_vz  {grp_cassette,  "upload vz..."};
	btn_upload_vz.events().click([&fm, &grp_cassette, &com_no]
	{
		bool is_open=true;
        //filebox fbox(fm, is_open);
        filebox fbox(fm, is_open);
        fbox.add_filter("VZF", "*.vz");
        fbox.add_filter("All Files", "*.*");

		auto fs = fbox.show() ? fbox.file() : "";
		//int uart_com_no = getCOMx();

		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		if (fs.size()) {
			int err = vz_upload(fs.c_str(), uart_com_no);

			if(err) {
				//msgbox box(&fm, "upload cass", msgbox::button_t::ok|msgbox::icon_error);
				//msgbox box(&fm, "upload cass", nana::msgbox::button_t::ok);
				nana::msgbox box("upload cass");
				box.icon(nana::msgbox::icon_error);
				box << "uploaded error";
				box.show();
			} else {
				//msgbox box(&fm, "upload cass", nana::msgbox::button_t::ok);
				nana::msgbox box("upload cass");
				box << "uploaded completed";
				box.show();
			}
		}
	});

	grp_cassette["btn_field"] << btn_upload_vz;

	// 模拟键盘 the keyboard group
	group nested_keyb(grp_keyboard.handle());
	label  lab {grp_keyboard,  "Emu Keyboard"};
	button btn_open_text  {grp_keyboard,  "Open text..."};
	btn_open_text.events().click([&fm, &grp_keyboard, &com_no]
	{
		bool is_open=true;
        //filebox fbox(fm, is_open);
        filebox fbox(fm, is_open);
        fbox.add_filter("Text Files", "*.txt;*.bas");
        fbox.add_filter("All Files", "*.*");

		auto fs = fbox.show() ? fbox.file() : "";
		//if(fs.size())
		//	fs.data();

		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}
	});
	grp_keyboard.div( "<vertical margin=2 gap=2 <vert lab> | <btn_field> >");
	grp_keyboard["lab"]  << lab.text_align(align::right) << nested_keyb ;
	//grp_keyboard["btn_field"] << btn_open_text ;

	// the nested_keyb (rigth up) group
	label lab1{nested_keyb,  "HOT KEY:"};
	nested_keyb.div( " margin=3 min=30 gap= 2 all");
	nested_keyb["all"]  << lab1;

	button btn_keyb_cload  {nested_keyb,  "CLOAD"};
	btn_keyb_cload.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"CLOAD\x0D", uart_com_no);
	});

	button btn_keyb_crun  {nested_keyb,  "CRUN"};
	btn_keyb_crun.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"CRUN\x0D", uart_com_no);
	});

	button btn_keyb_run  {nested_keyb,  "RUN"};
	btn_keyb_run.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"RUN\x0D", uart_com_no);
	});

	button btn_keyb_list  {nested_keyb,  "LIST"};
	btn_keyb_list.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"LIST\x0D", uart_com_no);
	});

	button btn_keyb_ctrl_break  {nested_keyb,  "CTRL+BREAK"};
	btn_keyb_ctrl_break.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"\x03", uart_com_no);
	});

	button btn_keyb_play_cass  {nested_keyb,  "PLAY CASS"};
	btn_keyb_play_cass.events().click([&fm, &grp_keyboard, &com_no]
	{
		int uart_com_no = com_no.option()+1;

		if(uart_com_no<1||uart_com_no>9) {
			nana::msgbox msgbox_com_err("COMx err");
			msgbox_com_err << "COM" << uart_com_no << " err";
			msgbox_com_err.show();
			return;
		}

		keyb_upload((const uint8_t*)"_", uart_com_no);
	});

	nested_keyb["all"] << btn_keyb_crun;
	nested_keyb["all"] << btn_keyb_cload;
	nested_keyb["all"] << btn_keyb_run;
	nested_keyb["all"] << btn_keyb_list;
	//nested_keyb["all"] << btn_keyb_ctrl_break;
	//nested_keyb["all"] << btn_keyb_play_cass;

	plc.collocate();
	//grp1.plc.collocate();    // OK


	fm.show();

	::nana::exec();
}
