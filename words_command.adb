with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

with Word_Lists;
with Split;


package body Words_Command is

	package ASU renames Ada.Strings.Unbounded;
	use Word_Lists;

	procedure 
		Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);

	procedure 
	Dispose_List (	Word_List: in out Word_List_Type) is
			Trasher: Word_List_Type;
    		begin --Dispose_List
			loop
				exit when Word_List = null;
				Trasher := Word_List;
				Word_List := Word_List.Next;
				Free(Trasher);
				end loop;
			end Dispose_List;

	--Lectura de los comandos
	procedure 
		Command_Input (selector: in out integer) is
			Argument_Excepcion: exception;
			begin --Command_Input
				if ACL.Argument_Count /= 2 then
					raise Argument_Excepcion;
    			end if;
				Ada.Text_Io.Put_Line(ACL.Argument(2));
			exception --Command_Input
				when Argument_Excepcion => Ada.Text_Io.Put_Line("At least one argument");
				end Command_Input;
				
	subtype selector_type is Integer range 0..5;
	function 
		Lounch_Interactive_Mode return selector_type is
			selector: selector_type :=0;
			begin --Lounch_Interactive_Mode
				T_IO.Put_Line("Options");
				T_IO.Put_Line("[1] Add word");
				T_IO.Put_Line("[2] Delete word");
				T_IO.Put_Line("[3] Search word");
				T_IO.Put_Line("[4] Show all words");
				T_IO.Put_Line("[5] Quit");
				I_IO.Get(selector);
				T_IO.Skip_Line;
				return selector;
			exception	--Lounch_Interactive_Mode
				when ADA.IO_EXCEPTIONS.DATA_ERROR =>
					selector:=0;
					T_IO.Skip_Line;
					return selector;
				end Lounch_Interactive_Mode;

	procedure 
		Interactive_Mode (List: in out Word_Lists.Word_List_Type) is
			stop: boolean:=false;
			selector: integer :=0;
			Word: ASU.Unbounded_String;
			Max: Natural:=1;
			begin
				while not stop loop
				selector:=Lounch_Interactive_Mode;
				case selector is
					when 1 =>
						T_IO.Put_Line("Selection: Add");
						T_IO.Put_Line("Write the word");
						Word := 
							ASU.To_Unbounded_String(
								T_IO.Get_Line);
    				Add_Word (
							List, 
							Split.Clean_Word(ASU.To_String(Word)));
					when 2 =>
						T_IO.Put_Line("Selection: Delete");
						if List = null then
							T_IO.Put_Line("No words to delete");
						else
							T_IO.Put_Line("Write the word");
							Word := ASU.To_Unbounded_String(T_IO.Get_Line);
							Delete_Word (List,Split.Clean_Word(ASU.To_String(Word)));
							end if;
					when 3 =>
						T_IO.Put_Line("Selection: Search");
						if List = null then
							T_IO.Put_Line("No words in text");
						else
							T_IO.Put_Line("Write the word");
							Word := ASU.To_Unbounded_String(T_IO.Get_Line);
							Search_Word (List,Split.Clean_Word(ASU.To_String(Word)),Max);
							if Max = 0 then
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
							Max := 0;
							Max_Word (List,Word,Max);
							T_IO.Put(ASU.To_String(Word));
							T_IO.Put(Integer'Image(Max));
							T_IO.Put_Line(" times.");
							end if;
						T_IO.Put_Line("Bye.");
						stop := true;
						Dispose_List(List);
					when others =>
						Ada.Text_IO.Put_Line("Not a valid statement. Choose a diferent case");
						end case;
					end loop;
				end Interactive_Mode;
	end Words_Command;
