unit DocumentApprovingSheetApprovingSetHolder;

interface

uses

  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentApprovingPerformingStatus = (prApproved, prApprovedWithNotes, prNotApproved, prOnApproving, prUnknown);

  TDocumentApprovingSheetApprovingSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      ApproverSpecialityFieldName: String;
      ApprovingPerformingStatusFieldName: String;
      IsApprovedWithNotesFieldName: String;
      ApprovingPerformingStatusNameFieldName: String;
      ApprovingPerformingDateFieldName: String;
      ApproverNameFieldName: String;
      NoteFieldName: String;
      
  end;
  
  TDocumentApprovingSheetApprovingSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    protected

      function GetApproverNameFieldName: String;
      function GetApproverSpecialityFieldName: String;
      function GetApprovingPerformingDateFieldName: String;
      function GetApprovingPerformingStatusFieldName: String;
      function GetIsApprovedWithNotesFieldName: String;
      function GetApprovingPerformingStatusNameFieldName: String;
      function GetNoteFieldName: String;

      function GetApproverNameFieldValue: String;
      function GetNoteFieldValue: String;
      function GetApproverSpecialityFieldValue: String;
      function GetApprovingPerformingDateFieldValue: Variant;
      function GetApprovingPerformingStatusFieldValue: TDocumentApprovingPerformingStatus;
      function GetIsApprovedWithNotesFieldValue: Boolean;
      function GetApprovingPerformingStatusNameFieldValue: String;

      function GetDocumentApprovingSheetApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs;

    protected

      procedure SetApproverNameFieldName(const Value: String);
      procedure SetNoteFieldName(const Value: String);
      procedure SetApproverSpecialityFieldName(const Value: String);
      procedure SetApprovingPerformingDateFieldName(const Value: String);
      procedure SetApprovingPerformingStatusFieldName(const Value: String);
      procedure SetIsApprovedWithNotesFieldName(const Value: String);
      procedure SetApprovingPerformingStatusNameFieldName(const Value: String);

      procedure SetNoteFieldValue(const Value: String);
      procedure SetApproverNameFieldValue(const Value: String);
      procedure SetApproverSpecialityFieldValue(const Value: String);
      procedure SetApprovingPerformingDateFieldValue(const Value: Variant);

      procedure SetApprovingPerformingStatusFieldValue(
        const Value: TDocumentApprovingPerformingStatus
      );

      procedure SetIsApprovedWithNotesFieldValue(const Value: Boolean);
      
      procedure SetApprovingPerformingStatusNameFieldValue(const Value: String);

      procedure SetDocumentApprovingSheetApprovingSetFieldDefs(
        const Value: TDocumentApprovingSheetApprovingSetFieldDefs
      );
      
    public

      property ApproverSpecialityFieldName: String
      read GetApproverSpecialityFieldName write SetApproverSpecialityFieldName;

      property ApprovingPerformingStatusFieldName: String
      read GetApprovingPerformingStatusFieldName write SetApprovingPerformingStatusFieldName;

      property IsApprovedWithNotesFieldName: String
      read GetIsApprovedWithNotesFieldName write SetIsApprovedWithNotesFieldName;
      
      property ApprovingPerformingStatusNameFieldName: String
      read GetApprovingPerformingStatusNameFieldName
      write SetApprovingPerformingStatusNameFieldName;

      property ApprovingPerformingDateFieldName: String
      read GetApprovingPerformingDateFieldName write SetApprovingPerformingDateFieldName;

      property ApproverNameFieldName: String
      read GetApproverNameFieldName write SetApproverNameFieldName;

      property NoteFieldName: String
      read GetNoteFieldName write SetNoteFieldName;
      
    public

      property ApproverSpecialityFieldValue: String
      read GetApproverSpecialityFieldValue write SetApproverSpecialityFieldValue;

      property ApprovingPerformingStatusFieldValue: TDocumentApprovingPerformingStatus
      read GetApprovingPerformingStatusFieldValue write SetApprovingPerformingStatusFieldValue;

      property IsApprovedWithNotesFieldValue: Boolean
      read GetIsApprovedWithNotesFieldValue write SetIsApprovedWithNotesFieldValue;
      
      property ApprovingPerformingStatusNameFieldValue: String
      read GetApprovingPerformingStatusNameFieldValue
      write SetApprovingPerformingStatusNameFieldValue;

      property ApprovingPerformingDateFieldValue: Variant
      read GetApprovingPerformingDateFieldValue write SetApprovingPerformingDateFieldValue;
      
      property ApproverNameFieldValue: String
      read GetApproverNameFieldValue write SetApproverNameFieldValue;

      property NoteFieldValue: String
      read GetNoteFieldValue write SetNoteFieldValue;
      
    public

      property FieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs
      read GetDocumentApprovingSheetApprovingSetFieldDefs
      write SetDocumentApprovingSheetApprovingSetFieldDefs;
      
  end;
  
  
implementation

{ TDocumentApprovingSheetApprovingSetHolder }

function TDocumentApprovingSheetApprovingSetHolder.GetApproverNameFieldName: String;
begin

  Result := FieldDefs.ApproverNameFieldName;

end;

function TDocumentApprovingSheetApprovingSetHolder.GetApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApproverNameFieldName, '');
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetApproverSpecialityFieldName: String;
begin

  Result := FieldDefs.ApproverSpecialityFieldName;

end;

function TDocumentApprovingSheetApprovingSetHolder.GetApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApproverSpecialityFieldName, '');
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetApprovingPerformingDateFieldName: String;
begin

  Result := FieldDefs.ApprovingPerformingDateFieldName;
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetApprovingPerformingDateFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ApprovingPerformingDateFieldName, 0);
  
end;

function TDocumentApprovingSheetApprovingSetHolder.
  GetApprovingPerformingStatusFieldName: String;
begin

  Result := FieldDefs.ApprovingPerformingStatusFieldName;

end;

function TDocumentApprovingSheetApprovingSetHolder.GetApprovingPerformingStatusFieldValue: TDocumentApprovingPerformingStatus;
begin

  Result := GetDataSetFieldValue(ApprovingPerformingStatusNameFieldName, prUnknown);

end;

function TDocumentApprovingSheetApprovingSetHolder.GetApprovingPerformingStatusNameFieldName: String;
begin

  Result := FieldDefs.ApprovingPerformingStatusNameFieldName;

end;

function TDocumentApprovingSheetApprovingSetHolder.GetApprovingPerformingStatusNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ApprovingPerformingStatusNameFieldName, '');
  
end;

class function TDocumentApprovingSheetApprovingSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingSheetApprovingSetFieldDefs;
  
end;

function TDocumentApprovingSheetApprovingSetHolder.
  GetDocumentApprovingSheetApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs;
begin

  Result := TDocumentApprovingSheetApprovingSetFieldDefs(inherited FieldDefs);

end;

function TDocumentApprovingSheetApprovingSetHolder.GetIsApprovedWithNotesFieldName: String;
begin

  Result := FieldDefs.IsApprovedWithNotesFieldName;
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetIsApprovedWithNotesFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsApprovedWithNotesFieldName, False);
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetNoteFieldName: String;
begin

  Result := FieldDefs.NoteFieldName;
  
end;

function TDocumentApprovingSheetApprovingSetHolder.GetNoteFieldValue: String;
begin

  Result := GetDataSetFieldValue(NoteFieldName, '');
  

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApproverNameFieldName(
  const Value: String);
begin

  FieldDefs.ApproverNameFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApproverNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ApproverNameFieldName, Value);
  
end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApproverSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.ApproverSpecialityFieldName := Value;
  
end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApproverSpecialityFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ApproverSpecialityFieldName, Value);
  
end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingDateFieldName(
  const Value: String);
begin

  FieldDefs.ApprovingPerformingDateFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingDateFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ApprovingPerformingDateFieldName, Value);
  
end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingStatusFieldName(
  const Value: String);
begin

  FieldDefs.ApprovingPerformingStatusFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingStatusFieldValue(
  const Value: TDocumentApprovingPerformingStatus);
begin

  SetDataSetFieldValue(ApprovingPerformingStatusFieldName, Value);

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingStatusNameFieldName(
  const Value: String);
begin

  FieldDefs.ApprovingPerformingStatusNameFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetApprovingPerformingStatusNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ApprovingPerformingStatusNameFieldName, Value);
  
end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetDocumentApprovingSheetApprovingSetFieldDefs(
  const Value: TDocumentApprovingSheetApprovingSetFieldDefs);
begin

  inherited FieldDefs := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetIsApprovedWithNotesFieldName(
  const Value: String);
begin

  FieldDefs.IsApprovedWithNotesFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetIsApprovedWithNotesFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsApprovedWithNotesFieldName, Value);

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetNoteFieldName(
  const Value: String);
begin

  FieldDefs.NoteFieldName := Value;

end;

procedure TDocumentApprovingSheetApprovingSetHolder.SetNoteFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(NoteFieldName, Value);
  
end;

end.
