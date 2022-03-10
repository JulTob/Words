with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Command_Line;
with Ada.Text_IO;
with Word_Lists;


package Control_Words is

        ---- Renames ----
	package T_IO 	renames Ada.Text_IO;
	package ACL 	renames Ada.Command_Line;
	package Int_IO 	is new Ada.Text_IO.Integer_IO(Integer);
        ------------------

	procedure 
	Lounch_Control_Mode( 
		List: in out Word_Lists.Word_List_Type; 
		stop: in out boolean) is
		selector:integer:=0;
		begin
			T_IO.Put_Line("Options");
			T_IO.Put_Line("[1] Add word");
			T_IO.Put_Line("[2] Delete word");
			T_IO.Put_Line("[3] Search word");
			T_IO.Put_Line("[4] Show all words");
			T_IO.Put_Line("[5] Quit");
			Int_IO.Get(selector);
			T_IO.Skip_Line;
		exception	
			when ADA.IO_EXCEPTIONS.DATA_ERROR =>
			selector:= 0;
			T_IO.Skip_Line;
		end lounch_control_mode;

	procedure 
	Dispose_List(
		Word_List: in out Word_Lists.Word_List_Type) is
		Trasher: Word_Lists.Word_List_Type;
		begin	loop 
			Trasher:= Word_List.Next;
			Word_List:= Word_List.Next;
			Free(Trasher);
			exit when 	Word_List = null;	
			end loop;
			end Dispose_List;

	procedure 
	Activate_Control_Mode (
		List: in out Word_Lists.Word_List_Type) is 
		stop: boolean := false;
		selector: integer := 0;
		word: ASU.Unbounded_String;
		Max: Natural := 1;
		begin
			while not stop loop 
				lounch_control_mode(stop, selector);
				case selector is
					when 1 =>
						T_IO.Put_Line("Selection: Add");
						T_IO.Put_Line("Write the word");
						Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
						Add_Word (List, Word);
					when 2 =>
						T_IO.Put_Line("Selection: Delete");
						if List=null then
							T_IO.Put_Line("No words to delete");
							else
								T_IO.Put_Line("Write the word");
								Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
								Delete_Word (List,Word);
								end if;
					when 3 =>
						T_IO.Put_Line("Selection: Search");
						if List = Null then
							T_IO.Put_Line("No words in text");
							else
								T_IO.Put_Line("Write the word");
								Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
								Search_Word (List,Word,Max);
								if Max=0 then
									T_IO.Put_Line("Word not found");
									else
										T_IO.Put("Word found ");
										T_IO.Put(Integer'Image(Max));
										T_IO.Put_Line(" times.");
									end if;
								end if;

					when 4 =>
						if List=null then
							T_IO.Put_Line("No words in text");
							else
								T_IO.Put_Line("Selection: Show all");
								word_lists.Print_All(List);
							end if;
					when 5 =>
						T_IO.Put_Line("Selection: Quit");
						if List=null then
							T_IO.Put_Line("No words in text");
							else
								T_IO.Put_Line("The most frequent word is:");
								Max:=0;
								Max_Word (List,Word,Max);

								T_IO.Put(ASU.To_String(Word));
								T_IO.Put(Integer'Image(Max));
								T_IO.Put_Line(" times.");
								end if;
						T_IO.Put_Line("Bye.");
						stop:=true;
					when others =>
						Ada.Text_IO.Put_Line("Not a valid statement. Choose a diferent case");
					end case;
					end loop;
			end Activate_Control_Mode;

end Control_Words;
