with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with word_lists;

--Split = Trocear 
package Split is

	package T_IO renames Ada.Text_IO;
	package UString renames Ada.Strings.Unbounded;	
	
function Clean_Word (Word_In:String) return UString.Unbounded_String ;
	
procedure Split_Line_In_Words(Frase: in out UString.Unbounded_String;
				List: in out word_lists.Word_List_Type);

procedure Split_Text_In_Words(Fichero: in T_IO.File_Type;
				List: in out word_lists.Word_List_Type);
	

end Split;
