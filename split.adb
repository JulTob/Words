with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Characters.Handling;
with word_lists;

package body Split is

	Package WL renames Word_Lists;
	Package CH renames Ada.Characters.Handling;
	
	function Clean_Word (Word_In:String) return UString.Unbounded_String is
		Word_Out: UString.Unbounded_String;
	begin --Clean_Word
		for ii in 1..Word_In'Length loop
			case Word_In(ii) is
			when 'a'..'z' =>
				Word_Out:=UString.To_Unbounded_String(UString.To_String(Word_Out) & Word_in(ii));
			when 'A'..'Z' =>
				Word_Out:=UString.To_Unbounded_String(UString.To_String(Word_Out) & CH.To_Lower(Word_in(ii)));
			when '0'..'9' =>
					Word_Out:=UString.To_Unbounded_String(UString.To_String(Word_Out) & Word_in(ii));
			when others =>
				Word_Out:=UString.To_Unbounded_String(UString.To_String(Word_Out) & " ");
			end case;
		end loop;
		return Word_Out;
	end Clean_Word;
	
	procedure Split_Line_In_Words(Frase: in out UString.Unbounded_String;
					List: in out WL.Word_List_Type) is 
	    Finish_Line: Boolean :=False;
	    Word: UString.Unbounded_String;
	    Position: Integer;
	begin --Split_Line_In_Words
    	Frase:=Clean_Word(UString.To_String(Frase));
		while not Finish_Line loop 
			Position:=UString.Index(Frase," ");
			if Position = 0 then 						
				Finish_Line:=True;		
			elsif Position=1 then 
				Frase:=UString.Tail(Frase,UString.Length(Frase)-Position);					
			else 
				Word:=UString.Head(Frase,Position-1);
				WL.Add_Word(List,Word);
				Frase:=UString.Tail(Frase,UString.Length(Frase)-Position);		
			end if;
		end loop;
	end Split_Line_In_Words;

	
	procedure Split_Text_In_Words(Fichero: in T_IO.File_Type;
					List: in out WL.Word_List_Type) is 
		Finish:Boolean:=False;
		Line:UString.Unbounded_String;
	begin --Split_Text_In_Words
		while not Finish loop 
		begin --control loop
			Line := UString.To_Unbounded_String(T_IO.Get_Line(Fichero));
			Split_Line_In_Words(Line,List);
		exception
			when Ada.IO_Exceptions.End_Error =>
				Finish := True;
		end;
		end loop;
	end Split_Text_In_Words;
end Split;
