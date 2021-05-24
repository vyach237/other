unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client, dbf, Vcl.Buttons, Data.SqlExpr,
  Data.DbxSqlite, FireDAC.Phys.ADS, FireDAC.Phys.ADSDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI;

type
  TForm1 = class(TForm)
    Dbf1: TDbf;
    FDConnection1: TFDConnection;
    FileOpenDialog1: TFileOpenDialog;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Button1: TButton;
    FDManager1: TFDManager;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDTable1: TFDTable;
    FDTableAdapter1: TFDTableAdapter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MyDBFile : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  AField : TField;
  i : Integer;
begin
//  AField := TLargeIntField.Create(Self);
//  AField.Name := 'IDField';
//  AField.FieldName := 'ID';
//  AField.DataSet := FDTable1;
//
//  AField := TWideStringField.Create(Self);
//  AField.Size := 80;
//  AField.Name := 'NameField';
//  AField.FieldName := 'Name';
//  AField.DataSet := FDTable1;

  for I := 0 to Dbf1.FieldCount - 1 do
  begin
    case Dbf1.FieldDefs[i].DataType of
      ftString: begin
                  AField:= TStringField.Create(Self);
                  AField.Size:= Dbf1.FieldDefs[i].Size;
                  AField.Name:= Dbf1.FieldDefs[i].Name;
                  AField.FieldName:= Dbf1.Fields[i].FieldName;
                  AField.DataSet:= FDTable1;
                end;
      ftDate: begin
                AField:= TDateField.Create(Self);
                AField.Name:= Dbf1.FieldDefs[i].Name;
                AField.FieldName:= Dbf1.Fields[i].FieldName;
                AField.DataSet:= FDTable1;
              end;
      ftFloat: begin
                AField:= TFloatField.Create(Self);
                AField.Name:= Dbf1.FieldDefs[i].Name;
                AField.FieldName:= Dbf1.Fields[i].FieldName;
                AField.DataSet:= FDTable1;
               end;
      ftLargeint: begin
                    AField:= TLargeintField.Create(Self);
                    AField.Name:= Dbf1.Fields[i].Name;
                    AField.FieldName:= Dbf1.Fields[i].FieldName;
                    AField.DataSet:= FDTable1;
                  end;
    end;

  end;

  FDConnection1.Params.Values['database'] := MyDBFile;
  FDConnection1.Connected:= True;

  FDTable1.TableName := Copy(ExtractFileName(Edit1.Text), 1, Pos('.', ExtractFileName(Edit1.Text))-1);
  FDTable1.CreateTable(False, [tpTable]);
  FDTable1.Open();

  Dbf1.First;
  while not Dbf1.Eof do
  begin
    FDTable1.Insert;
    for I := 0 to Dbf1.FieldCount - 1 do
    begin
      FDTable1.FieldByName(Dbf1.Fields[i].FieldName).AsVariant:= Dbf1.Fields[i].AsVariant
    end;
    FDTable1.Post;
    Dbf1.Next;
  end;

  FDConnection1.Commit;

  FDConnection1.Connected:= False;
end;

procedure Test;
var
  Connection : TFDConnection;
  DriverLink : TFDPhysSQLiteDriverLink;
  Table : TFDTable;
  i : Integer;
begin
  DeleteFile( Form1.MyDBFile );
  DriverLink := TFDPhysSQLiteDriverLink.Create( nil );
  Connection := TFDConnection.Create( nil );
  try
    Connection.Params.Values['DriverID'] := 'SQLite';
    Connection.Params.Values['Database'] := Form1.MyDBFile;
    Connection.Connected := True;

//    Table := TFDTable.Create( nil );
//    try
//      Table.TableName := ExpandFileName(Form1.Edit1.Text);
//      Table.Connection := Connection;
//      for I := 0 to Form1.Dbf1.FieldCount - 1 do
//        Table.FieldDefs.Add(Form1.Dbf1.FieldDefs[i].DisplayName, Form1.Dbf1.FieldDefs[i].DataType, Form1.Dbf1.FieldDefs[i].Size);
//      Table.CreateDataSet;
//    finally
//      Table.Free;
//    end;
  finally
    Connection.Free;
    DriverLink.Free;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
    if FileOpenDialog1.FileName <> '' then
    begin
      Dbf1.TableName:= FileOpenDialog1.FileName;
      Dbf1.Open;
      Edit1.Text:= FileOpenDialog1.FileName;
      MyDBFile:= ChangeFileExt(Edit1.Text, '.sqlite3');
      if MessageDlg('Конвертировать в SQLITE3?', mtConfirmation, mbYesNo, 0) = mrYes then
      begin
        Test;
        Button1Click(nil);
        ShowMessage('OK');
//        FDConnection1.Connected:=false;
//        FDConnection1.Params.Clear;
//        FDConnection1.Params.Database:=ChangeFileExt(FileOpenDialog1.FileName, '.sdb3');
//        FDConnection1.ConnectionDefName:='SQLite_Demo';
//        FDConnection1.DriverName:='SQLite';
//        FDConnection1.Connected:=true;
      end;
    end;
end;

end.
