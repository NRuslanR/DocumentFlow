unit DocumentApprovingListRecordSetHolder;

interface

uses

  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentApprovingListRecordSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      ListTitleFieldName: String;
      ApproverNameFieldName: String;
      ApproverSpecialityFieldName: String;
      ApprovingPerformingResultFieldName: String;

      
  end;

  TDocumentApprovingListRecordSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    protected
    
      function GetApproverNameFieldName: String;
      function GetApproverNameFieldValue: String;
      function GetApproverSpecialityFieldName: String;
      function GetApproverSpecialityFieldValue: String;
      function GetApprovingPerformingResultFieldName: String;
      function GetApprovingPerformingResultFieldValue: String;
      function GetListTitleFieldName: String;
      function GetListTitleFieldValue: String;

      function GetDocumentApprovingListRecordSetFieldDefs:
        TDocumentApprovingListRecordSetFieldDefs;
        
      procedure SetApproverNameFieldName(const Value: String);
      procedure SetApproverNameFieldValue(const Value: String);
      procedure SetApproverSpecialityFieldName(const Value: String);
      procedure SetApproverSpecialityFieldValue(const Value: String);
      procedure SetApprovingPerformingResultFieldName(const Value: String);
      procedure SetApprovingPerformingResultFieldValue(const Value: String);
      procedure SetListTitleFieldName(const Value: String);
      procedure SetListTitleFieldValue(const Value: String);

      procedure SetDocumentApprovingListRecordSetFieldDefs(
        const Value: TDocumentApprovingListRecordSetFieldDefs
      );

    public

      procedure FilterByListTitleField(const ListTitle: String);
      
    public

      property ListTitleFieldName: String
      read GetListTitleFieldName write SetListTitleFieldName;
      
      property ApproverNameFieldName: String
      read GetApproverNameFieldName write SetApproverNameFieldName;
      
      property ApproverSpecialityFieldName: String
      read GetApproverSpecialityFieldName write SetApproverSpecialityFieldName;
      
      property ApprovingPerformingResultFieldName: String
      read GetApprovingPerformingResultFieldName
      write SetApprovingPerformingResultFieldName;

    public

      property ListTitleFieldValue: String
      read GetListTitleFieldValue write SetListTitleFieldValue;

      property ApproverNameFieldValue: String
      read GetApproverNameFieldValue write SetApproverNameFieldValue;

      property ApproverSpecialityFieldValue: String
      read GetApproverSpecialityFieldValue write SetApproverSpecialityFieldValue;

      property ApprovingPerformingResultFieldValue: String
      read GetApprovingPerformingResultFieldValue
      write SetApprovingPerformingResultFieldValue;

    public

      property FieldDefs: TDocumentApprovingListRecordSetFieldDefs
      read GetDocumentApprovingListRecordSetFieldDefs
      write SetDocumentApprovingListRecordSetFieldDefs;
      
  end;
  
implementation

{ TDocumentApprovingListRecordSetHolder }

procedure TDocumentApprovingListRecordSetHolder.FilterByListTitleField(
  const ListTitle: String);
begin

  ApplyFilter(Format('%s=%s', [ListTitleFieldName, QuotedStr(ListTitle)]));
  
end;

function TDocumentApprovingListRecordSetHolder.GetApproverNameFieldName: String;
begin

  Result := FieldDefs.ApproverNameFieldName;
  
end;

function TDocumentApprovingListRecordSetHolder.GetApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApproverNameFieldName, '');

end;

function TDocumentApprovingListRecordSetHolder.GetApproverSpecialityFieldName: String;
begin

  Result := FieldDefs.ApproverSpecialityFieldName;

end;

function TDocumentApprovingListRecordSetHolder.GetApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApproverSpecialityFieldName, '');
  
end;

function TDocumentApprovingListRecordSetHolder.GetApprovingPerformingResultFieldName: String;
begin

  Result := FieldDefs.ApprovingPerformingResultFieldName;

end;

function TDocumentApprovingListRecordSetHolder.GetApprovingPerformingResultFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApprovingPerformingResultFieldName, '');
  
end;

class function TDocumentApprovingListRecordSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingListRecordSetFieldDefs;
  
end;

function TDocumentApprovingListRecordSetHolder.
  GetDocumentApprovingListRecordSetFieldDefs: TDocumentApprovingListRecordSetFieldDefs;
begin

  Result := TDocumentApprovingListRecordSetFieldDefs(FFieldDefs);
  
end;

function TDocumentApprovingListRecordSetHolder.GetListTitleFieldName: String;
begin

  Result := FieldDefs.ListTitleFieldName;
  
end;

function TDocumentApprovingListRecordSetHolder.GetListTitleFieldValue: String;
begin

  Result := GetDataSetFieldValue(ListTitleFieldName, '');
  
end;

procedure TDocumentApprovingListRecordSetHolder.SetApproverNameFieldName(
  const Value: String);
begin

  FieldDefs.ApproverNameFieldName := Value;

end;

procedure TDocumentApprovingListRecordSetHolder.SetApproverNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ApproverNameFieldName, Value);
  
end;

procedure TDocumentApprovingListRecordSetHolder.SetApproverSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.ApproverSpecialityFieldName := Value;
  
end;

procedure TDocumentApprovingListRecordSetHolder.SetApproverSpecialityFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ApproverSpecialityFieldName, Value);
  
end;

procedure TDocumentApprovingListRecordSetHolder.
  SetApprovingPerformingResultFieldName(
    const Value: String
  );
begin

  FieldDefs.ApprovingPerformingResultFieldName := Value;

end;

procedure TDocumentApprovingListRecordSetHolder.
  SetApprovingPerformingResultFieldValue(
    const Value: String
  );
begin

  SetDataSetFieldValue(ApprovingPerformingResultFieldName, Value);
  
end;

procedure TDocumentApprovingListRecordSetHolder.
  SetDocumentApprovingListRecordSetFieldDefs(
    const Value: TDocumentApprovingListRecordSetFieldDefs
  );
begin

  SetFieldDefs(Value);

end;

procedure TDocumentApprovingListRecordSetHolder.SetListTitleFieldName(
  const Value: String);
begin

  FieldDefs.ListTitleFieldName := Value;

end;

procedure TDocumentApprovingListRecordSetHolder.SetListTitleFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ListTitleFieldName, Value);
  
end;

end.
