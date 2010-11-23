unit nam_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Menus, ExtCtrls, StdCtrls, Grids, Buttons;

type alphabet = set of char;

type slovo = string[255];

type table = array[1..2, 1..255] of slovo;

type
  { TfrmMain }
  TfrmMain = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    btnStart: TBitBtn;
    btnSlovoBlock: TSpeedButton;
    btnSlovoApply: TSpeedButton;
    chbProbil: TCheckBox;
    lblSlovo: TLabel;
    lblComment: TLabel;
    lblTable: TLabel;
    lblAlphabet: TLabel;
    MainMenu: TMainMenu;
    memoSlovo: TMemo;
    memoDebug: TMemo;
    memoAplhabet: TMemo;
    MenuItem1: TMenuItem;
    miAboutNAM: TMenuItem;
    miAbout: TMenuItem;
    MenuItem2: TMenuItem;
    miLoadA: TMenuItem;
    miLoadT: TMenuItem;
    miLoadS: TMenuItem;
    MenuItem6: TMenuItem;
    miSaveOutput: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    sgTable: TStringGrid;
    sbtnNewRow: TSpeedButton;
    sbtnDeleteRow: TSpeedButton;
    sbtnUpRow: TSpeedButton;
    sbtnDownRow: TSpeedButton;
    btnAlphabetBlock: TSpeedButton;
    btnAlphabetApply: TSpeedButton;
    btnTableApply: TSpeedButton;
    btnTalbeBlock: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAlphabetApplyClick(Sender: TObject);
    procedure btnAlphabetBlockClick(Sender: TObject);
    procedure btnSlovoApplyClick(Sender: TObject);
    procedure btnSlovoBlockClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnTableApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memoDebugChange(Sender: TObject);
    procedure memoDebugClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure miLoadAClick(Sender: TObject);
    procedure sbtnDeleteRowClick(Sender: TObject);
    procedure sbtnDownRowClick(Sender: TObject);
    procedure sbtnNewRowClick(Sender: TObject);
    procedure sbtnUpRowClick(Sender: TObject);
    procedure btnTalbeBlockClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;
  A : alphabet;
  T : table;
  N : integer;
  S1 : slovo;

implementation

{ TfrmMain }

function CheckSlovo(const s : slovo; const al : alphabet) : boolean;
var res : boolean = true;
    i : integer;
begin
  for i:=1 to length(s) do
    if (not (s[i] in al)) then
    Begin
      res:=false;
      break;
    end;
  CheckSlovo:=res;
end;

function CheckTable(var err : string) : boolean;
var res : boolean = true;
    i, j : integer;
Begin
  err:='';
  with frmMain.sgTable do
    for i:=1 to 2 do
    Begin
     for j:=1 to RowCount-1 do
       if (not CheckSlovo(Cells[i, j], A)) then
       Begin
         res:=false;
         break;
       end;
     if not res then
     Begin
       err:='[рядок '+IntToStr(j)+', стовпець '+IntToStr(i)+'] : '+Cells[i, j];
       break;
     end;
    end;

  CheckTable:=res;
end;

function ToAlphabet(const str : string; var al : alphabet) : boolean;
var res : boolean = true;
    i : integer;
begin
  al:=[];
  for i:=1 to length(str) do
    if (not (str[i] in al)) then
    Begin
      if str[i]<>' ' then
        al:=al+[str[i]];
    end
    else
    Begin
      res:=false;
      break;
    end;
  if (frmMain.chbProbil.Checked)AND(res) then al:=al+[' '];
  ToAlphabet:=res;
end;

function AlphabetApply(const str : string) : boolean;
var res : boolean = false;
Begin
  if ToAlphabet(str, A) then res:=true
  else res:=false;
  AlphabetApply:=res;
End;

procedure SGMoveRow(SG: TStringGrid; FromRow, ToRow: Integer);
var
  TempList : TStringList;
  i : Integer;
  s : string;
begin
  with SG do
    begin
      TempList := TStringList.Create;
      TempList.Assign(Rows[FromRow]);
      if FromRow > ToRow then
        for i := FromRow downto ToRow + 1 do
          Rows[i].Assign(Rows[i - 1])
      else
        for i := FromRow to ToRow - 1 do
          Rows[i].Assign(Rows[i + 1]);
      Rows[ToRow].Assign(TempList);
      TempList.Free;
      s:=Cells[0, FromRow];
      Cells[0, FromRow]:=Cells[0, ToRow];
      Cells[0, ToRow]:=s;
    end;
end;

procedure MakeTable(var tab : table);
var i, j : integer;
begin
  with frmMain.sgTable do
  Begin
    for i:=1 to 2 do
      for j:=1 to RowCount-1 do
        tab[i,j]:=Cells[i,j];
    N:=RowCount-1;
  end;
end;

procedure TfrmMain.MenuItem1Click(Sender: TObject);
begin

end;

procedure TfrmMain.MenuItem9Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.btnAlphabetApplyClick(Sender: TObject);
var s : string;
begin
  s:=memoAplhabet.Text;
  A:=[];
  if ToAlphabet(s, A) then
  Begin
    ShowMessage('Алфавіт успішно застосований!');
    btnAlphabetBlock.Click;
  end
  else
  Begin
    MessageDlg('Виникла помилка!', 'Виникла помилка при задані алфавіту!'+#13+
         'Виправте помилку й натисніть кнопку "застосувати" знову.', mtError, [mbOK], 0);
    A:=[];
  end;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var a, b, c : string;
    i,  j : integer;
begin
  a:='qwertyuiop';
  b:='rt';
  c:='xxx';
  i:=Pos(b, a);
  delete(a, i, length(b));
  insert(c, a, i);
end;

procedure TfrmMain.btnAlphabetBlockClick(Sender: TObject);
begin
 memoAplhabet.Enabled:=not memoAplhabet.Enabled;
  chbProbil.Enabled:=not chbProbil.Enabled;
end;

procedure TfrmMain.btnSlovoApplyClick(Sender: TObject);
var s : string;
begin

  s:=memoSlovo.Text;
  if CheckSlovo(s,A) then
  Begin
    ShowMessage('Слово успішно застосоване!');
    btnSlovoBlock.Click;
    S1:=s;
  end
  else MessageDlg('Виникла помилка!', 'Виникла помилка при задані слова S!'+#13+
         'Вказане слово не відповідає заданому алфавіту!'+#13+
         'Виправте помилку й натисніть кнопку "застосувати" знову.', mtError, [mbOK], 0);

end;

procedure TfrmMain.btnSlovoBlockClick(Sender: TObject);
begin
  memoSlovo.Enabled:=not memoSlovo.Enabled;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var treba : boolean = true;
    i, j : integer;
begin
  if S1<>'' then
  Begin
    i:=1;
    while treba do
    Begin
      j:=Pos(T[1,i], S1);
      if j=0 then
      begin
        memoDebug.Lines.Add(S1+' '+inttostr(i));
        if i<N then inc(i)
        else treba:=false;
      end
      else
      begin
        delete(S1, j, length(T[1, i]));
        insert(T[2, i], S1, j);
        memoDebug.Lines.Add(S1+' '+inttostr(i));
        i:=1;
      end;
    end;
    ShowMessage(S1);
  end
  else
    ShowMessage('Ви не застосували слово!');

end;

procedure TfrmMain.btnTableApplyClick(Sender: TObject);
var errstr : string;
begin
  if CheckTable(errstr) then
  Begin
    MakeTable(T);
    ShowMessage('Таблиця успішно застосована і не містить помилок!');
    btnTalbeBlock.Click;
  end
  else MessageDlg('Виникла помилка!', 'Виникла помилка при задані таблиці Т!'+#13+
         errstr+#13+
         'Виправте помилку й натисніть кнопку "застосувати" знову.', mtError, [mbOK], 0);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  A:=[];
  S1:='';
end;

procedure TfrmMain.memoDebugChange(Sender: TObject);
begin

end;

procedure TfrmMain.memoDebugClick(Sender: TObject);
var i, j : integer;
    str_al : string;
begin
  memoDebug.Clear;
  memoDebug.Lines.Add('Алфавіт:');

  str_al:='';
  for i:=1 to 255 do
    if chr(i) in A then
      str_al:=str_al+'  '+chr(i);
  memoDebug.Lines.Add(str_al);

  memoDebug.Lines.Add('Таблиця:');

  for j:=1 to sgTable.RowCount-1 do
    Begin
      str_al:='';
      for i:=1 to 2 do
        str_al:=str_al+'     '+sgTable.Cells[i,j];
      memoDebug.Lines.Add(str_al);
    end;

  memoDebug.Lines.Add('Слово: '+S1);

end;

procedure TfrmMain.miLoadAClick(Sender: TObject);
begin

end;

procedure TfrmMain.sbtnDeleteRowClick(Sender: TObject);
var i, temp : integer;
begin
  with sgTable do
  begin
    i:=Row;
    temp:=i;
    if RowCount<>2 then
    Begin
      while i<RowCount-1 do
      begin
        Cells[0,i]:=Cells[0,i+1];
        Cells[1,i]:=Cells[1,i+1];
        Cells[2,i]:=Cells[2,i+1];
        inc(i);
      end;
      RowCount:=RowCount-1;

      for i:=temp to RowCount-1 do
        Cells[0,i]:=inttostr(i);
    end
    else MessageDlg('Виникла помилка!', 'Виникла помилка при нумерації рядків таблиці Т:'+#13+
         'в таблиці повинен бути принаймні один рядок!', mtWarning, mbOKCancel, 0);
  end;
end;

procedure TfrmMain.sbtnDownRowClick(Sender: TObject);
begin
  with sgTable do
  if (Row in [1..RowCount - 2]) then
    Begin
      SGMoveRow(sgTable, Row, Row+1);
      Row:=Row+1;
    end;
end;

procedure TfrmMain.sbtnUpRowClick(Sender: TObject);
begin
  with sgTable do
  if (Row in [2..RowCount - 1]) then
    Begin
      SGMoveRow(sgTable, Row, Row-1);
      Row:=Row-1;
    end;
end;

procedure TfrmMain.btnTalbeBlockClick(Sender: TObject);
begin
  sgTable.Enabled:=not sgTable.Enabled;
end;

procedure TfrmMain.sbtnNewRowClick(Sender: TObject);
var i : integer;
begin
  with sgTable do
  begin
    RowCount:=RowCount+1;
    if TryStrToInt(Cells[0,RowCount-2], i) then
      Cells[0,RowCount-1]:=inttostr(i+1)
    else
      MessageDlg('Виникла помилка!', 'Виникла помилка при нумерації рядків таблиці Т!', mtWarning, mbOKCancel, 0);
  end;
end;



initialization
  {$I nam_main.lrs}

end.

