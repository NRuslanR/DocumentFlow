unit DocumentFileSetHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentFileSetFieldDefs = class (TAbstractDataSetFieldDefs)

    private

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);
    
    public

      FileNameFieldName: String;
      FilePathFieldName: String;

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
  end;

  TDocumentFileSetHolder = class (TAbstractDataSetHolder)

    private

    protected

      function GetDocumentFileSet: TDataSet;
      function GetFieldDefs: TDocumentFileSetFieldDefs;
      function GetFileNameFieldName: String;
      function GetFileNameFieldValue: String;
      function GetFilePathFieldName: String;
      function GetFilePathFieldValue: String;
      function GetIdFieldName: String;
      function GetIdFieldValue: Variant;
      
      procedure SetDocumentFileSet(const Value: TDataSet);
      procedure SetFieldDefs(const Value: TDocumentFileSetFieldDefs);
      procedure SetIdFieldName(const Value: String);
      procedure SetFileNameFieldName(const Value: String);
      procedure SetFileNameFieldValue(const Value: String);
      procedure SetFilePathFieldName(const Value: String);
      procedure SetFilePathFieldValue(const Value: String);
      procedure SetIdFieldValue(const Value: Variant);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public
    
      procedure AddDocumentFileRecord(
        const FileName, FilePath: String
      );
      
      property DocumentFileSet: TDataSet
      read GetDocumentFileSet write SetDocumentFileSet;

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property FileNameFieldName: String
      read GetFileNameFieldName write SetFileNameFieldName;

      property IdFieldValue: Variant
      read GetIdFieldValue write SetIdFieldValue;
      
      property FileNameFieldValue: String
      read GetFileNameFieldValue write SetFileNameFieldValue;

      property FilePathFieldName: String
      read GetFilePathFieldName write SetFilePathFieldName;

      property FilePathFieldValue: String
      read GetFilePathFieldValue write SetFilePathFieldValue;

    published

      property FieldDefs: TDocumentFileSetFieldDefs
      read GetFieldDefs write SetFieldDefs;

  end;
  
implementation

uses

  Variants;
  
{ TDocumentFileSetFieldDefs }

function TDocumentFileSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentFileSetFieldDefs.SetIdFieldName(const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

{ TDocumentFileSetHolder }

procedure TDocumentFileSetHolder.AddDocumentFileRecord(const FileName,
  FilePath: String);
begin

  Append;

  SetFieldValue(FileNameFieldName, FileName);
  SetFieldValue(FilePathFieldName, FilePath);

  MarkCurrentRecordAsAdded;

  Post;
  
end;

class function TDocumentFileSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFileSetFieldDefs;
  
end;

function TDocumentFileSetHolder.GetDocumentFileSet: TDataSet;
begin

  Result := DataSet;
  
end;

function TDocumentFileSetHolder.GetFieldDefs: TDocumentFileSetFieldDefs;
begin

  Result := TDocumentFileSetFieldDefs(inherited FieldDefs);

end;

function TDocumentFileSetHolder.GetFileNameFieldName: String;
begin

  Result := FieldDefs.FileNameFieldName;

end;

function TDocumentFileSetHolder.GetFileNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FileNameFieldName, '');

end;

function TDocumentFileSetHolder.GetFilePathFieldName: String;
begin

  Result := FieldDefs.FilePathFieldName;
  
end;

function TDocumentFileSetHolder.GetFilePathFieldValue: String;
begin

  Result := GetDataSetFieldValue(FilePathFieldName, '');

end;

function TDocumentFileSetHolder.GetIdFieldName: String;
begin

  Result := FieldDefs.IdFieldName;

end;

function TDocumentFileSetHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IdFieldName, Null);

end;

procedure TDocumentFileSetHolder.SetDocumentFileSet(const Value: TDataSet);
begin

  DataSet := Value;
  
end;

procedure TDocumentFileSetHolder.SetFieldDefs(
  const Value: TDocumentFileSetFieldDefs);
begin

  inherited FieldDefs := Value;

end;

procedure TDocumentFileSetHolder.SetFileNameFieldName(const Value: String);
begin

  FieldDefs.FileNameFieldName := Value;

end;

procedure TDocumentFileSetHolder.SetFileNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(FileNameFieldName, Value);
  
end;

procedure TDocumentFileSetHolder.SetFilePathFieldName(const Value: String);
begin

  FieldDefs.FilePathFieldName := Value;
  
end;

procedure TDocumentFileSetHolder.SetFilePathFieldValue(const Value: String);
begin

  SetDataSetFieldValue(FilePathFieldName, Value);
  
end;

procedure TDocumentFileSetHolder.SetIdFieldName(const Value: String);
begin

  FieldDefs.IdFieldName := Value;

end;

procedure TDocumentFileSetHolder.SetIdFieldValue(const Value: Variant);
begin

  RecordIdFieldValue := Value;
  
end;

end.
