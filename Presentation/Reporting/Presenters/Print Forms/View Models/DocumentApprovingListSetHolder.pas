unit DocumentApprovingListSetHolder;

interface

uses

  DocumentApprovingListRecordSetHolder,
  AbstractDataSetHolder,
  DB,
  SysUtils,
  Classes;

type

  TDocumentApprovingListSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      TitleFieldName: String;
      
  end;
  
  TDocumentApprovingListSetHolder = class (TAbstractDataSetHolder)

    protected

      FApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;

      
    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    private
    
      function GetDocumentApprovingListSetFieldDefs: TDocumentApprovingListSetFieldDefs;
      function GetTitleFieldName: String;
      function GetTitleFieldValue: String;

      procedure SetApprovingListRecordSetHolder(
        const Value: TDocumentApprovingListRecordSetHolder
      );

      procedure SetDocumentApprovingListSetFieldDefs(
        const Value: TDocumentApprovingListSetFieldDefs
      );
      procedure SetTitleFieldName(const Value: String);
      procedure SetTitleFieldValue(const Value: String);

    public

      constructor Create; overload;
      constructor Create(ApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder); overload;

      property TitleFieldName: String read GetTitleFieldName write SetTitleFieldName;
      property TitleFieldValue: String read GetTitleFieldValue write SetTitleFieldValue;

      property ApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder
      read FApprovingListRecordSetHolder write SetApprovingListRecordSetHolder;
      
      property FieldDefs: TDocumentApprovingListSetFieldDefs
      read GetDocumentApprovingListSetFieldDefs
      write SetDocumentApprovingListSetFieldDefs;

  end;

implementation

{ TDocumentApprovingListSetHolder }

constructor TDocumentApprovingListSetHolder.Create(
  ApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder);
begin

  inherited Create;

  FApprovingListRecordSetHolder := ApprovingListRecordSetHolder;
  
end;

constructor TDocumentApprovingListSetHolder.Create;
begin

  inherited;
  
end;

class function TDocumentApprovingListSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingListSetFieldDefs;
  
end;

function TDocumentApprovingListSetHolder.GetDocumentApprovingListSetFieldDefs: TDocumentApprovingListSetFieldDefs;
begin

  Result := TDocumentApprovingListSetFieldDefs(inherited FieldDefs);

end;

function TDocumentApprovingListSetHolder.GetTitleFieldName: String;
begin

  Result := FieldDefs.TitleFieldName;

end;

function TDocumentApprovingListSetHolder.GetTitleFieldValue: String;
begin

  Result := GetDataSetFieldValue(TitleFieldName, '');
  
end;

procedure TDocumentApprovingListSetHolder.SetApprovingListRecordSetHolder(
  const Value: TDocumentApprovingListRecordSetHolder);
begin

  if FApprovingListRecordSetHolder = Value then Exit;

  FreeAndNil(FApprovingListRecordSetHolder);
  
  FApprovingListRecordSetHolder := Value;

end;

procedure TDocumentApprovingListSetHolder.SetDocumentApprovingListSetFieldDefs(
  const Value: TDocumentApprovingListSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TDocumentApprovingListSetHolder.SetTitleFieldName(
  const Value: String);
begin

  FieldDefs.TitleFieldName := Value;

end;

procedure TDocumentApprovingListSetHolder.SetTitleFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(TitleFieldName, Value);
  
end;

end.
