unit DocumentApprovingList;

interface

uses

  DomainObjectValueUnit,
  DomainObjectValueListUnit,
  Employee,
  IDomainObjectUnit,
  DocumentApprovings,
  IDomainObjectValueListUnit,
  SysUtils,
  Classes;

type

   TDocumentApprovingListRecord = class (TDomainObjectValue)

    protected

      FApprover: TEmployee;
      FFreeApprover: IDomainObject;

      FApprovingPerformingResult: TDocumentApprovingPerformingResult;

      procedure SetApprover(const Value: TEmployee);

    public

      constructor Create; overload;
      constructor Create(
        Approver: TEmployee;
        ApprovingPerformingResult: TDocumentApprovingPerformingResult
      ); overload;

      property Approver: TEmployee
      read FApprover write SetApprover;

      property ApprovingPerformingResult: TDocumentApprovingPerformingResult
      read FApprovingPerformingResult
      write FApprovingPerformingResult;

  end;

  TDocumentApprovingListRecords = class;

  TDocumentApprovingListRecordsEnumerator = class (TDomainObjectValueListEnumerator)

    protected

      function GetCurrentDocumentApprovingListRecord: TDocumentApprovingListRecord;

    public

      constructor Create(DocumentApprovingListRecords: TDocumentApprovingListRecords);

      property Current: TDocumentApprovingListRecord
      read GetCurrentDocumentApprovingListRecord;

  end;

  TDocumentApprovingListRecords = class (TDomainObjectValueList)

    protected

      function GetDocumentApprovingListRecordByIndex(Index: Integer): TDocumentApprovingListRecord;
      procedure SetDocumentApprovingListRecordByIndex(
        Index: Integer;
        DocumentApprovingListRecord: TDocumentApprovingListRecord
      );

    public

      procedure Add(DocumentApprovingListRecord: TDocumentApprovingListRecord);

      function FindApprovingListRecordForApprover(
        Approver: TEmployee
      ): TDocumentApprovingListRecord;

      function IsApprovingListRecordExistsForApprover(
        Approver: TEmployee
      ): Boolean;
      
      procedure RemoveApprovingListRecordForApprover(
        Approver: TEmployee
      );

      function GetEnumerator: TDocumentApprovingListRecordsEnumerator;

      property Items[Index: Integer]: TDocumentApprovingListRecord
      read GetDocumentApprovingListRecordByIndex
      write SetDocumentApprovingListRecordByIndex; default;
      
  end;

  TDocumentApprovingListKind = (alkApproving, alkViseing);

  TDocumentApprovingList = class (TDomainObjectValue)

    protected

      FTitle: String;
      FKind: TDocumentApprovingListKind;
      FRecords: TDocumentApprovingListRecords;

    public

      destructor Destroy; override;
      constructor Create;
      
      procedure AddRecordFor(
        Approver: TEmployee;
        ApprovingPerformingResult: TDocumentApprovingPerformingResult
      );

      procedure RemoveRecordForApprover(Approver: TEmployee);

      function IsRecordContainedForApprover(Approver: TEmployee): Boolean;
      
      property Records: TDocumentApprovingListRecords
      read FRecords;

      property Title: String read FTitle write FTitle;
      property Kind: TDocumentApprovingListKind read FKind write FKind;

  end;

  TDocumentApprovingLists = class;
  
  TDocumentApprovingListsEnumerator = class (TDomainObjectValueListEnumerator)

    protected

      function GetCurrentDocumentApprovingList: TDocumentApprovingList;

    public

      constructor Create(DocumentApprovingLists: TDocumentApprovingLists);

      property Current: TDocumentApprovingList
      read GetCurrentDocumentApprovingList;
      
  end;

  TDocumentApprovingLists = class (TDomainObjectValueList)

    private
    function GetDocumentApprovingListByIndex(
      Index: Integer): TDocumentApprovingList;
    procedure SetDocumentApprovingListByIndex(Index: Integer;
      const Value: TDocumentApprovingList);

    protected
    
    public

      function First: TDocumentApprovingList;
      function Last: TDocumentApprovingList;
      
      procedure Add(DocumentApprovingList: TDocumentApprovingList);

      function Contains(DocumentApprovingList: TDocumentApprovingList): Boolean;

      procedure Remove(DocumentApprovingList: TDocumentApprovingList);

      function GetEnumerator: TDocumentApprovingListsEnumerator; virtual;

      property Items[Index: Integer]: TDocumentApprovingList
      read GetDocumentApprovingListByIndex
      write SetDocumentApprovingListByIndex; default;
      
  end;

implementation

{ TDocumentApprovingListRecordsEnumerator }

constructor TDocumentApprovingListRecordsEnumerator.Create(
  DocumentApprovingListRecords: TDocumentApprovingListRecords);
begin

  inherited Create(DocumentApprovingListRecords);
  
end;

function TDocumentApprovingListRecordsEnumerator.GetCurrentDocumentApprovingListRecord: TDocumentApprovingListRecord;
begin

  Result := TDocumentApprovingListRecord(GetCurrentDomainObjectValue);

end;

{ TDocumentApprovingListRecord }

constructor TDocumentApprovingListRecord.Create(Approver: TEmployee;
  ApprovingPerformingResult: TDocumentApprovingPerformingResult);
begin

  inherited Create;

  Self.Approver := Approver;
  Self.ApprovingPerformingResult := ApprovingPerformingResult;
  
end;

constructor TDocumentApprovingListRecord.Create;
begin

  inherited;
  
end;

procedure TDocumentApprovingListRecord.SetApprover(const Value: TEmployee);
begin

  FApprover := Value;
  FFreeApprover := FApprover;

end;

{ TDocumentApprovingListRecords }

procedure TDocumentApprovingListRecords.Add(
  DocumentApprovingListRecord: TDocumentApprovingListRecord);
begin

  AddDomainObjectValue(DocumentApprovingListRecord);
  
end;

function TDocumentApprovingListRecords.FindApprovingListRecordForApprover(
  Approver: TEmployee): TDocumentApprovingListRecord;
begin

  for Result in Self do
    if Result.Approver.IsSameAs(Approver) then
      Exit;

  Result := nil;

end;

function TDocumentApprovingListRecords.GetDocumentApprovingListRecordByIndex(
  Index: Integer): TDocumentApprovingListRecord;
begin

  Result := TDocumentApprovingListRecord(GetDomainObjectValueByIndex(Index));

end;

function TDocumentApprovingListRecords.GetEnumerator: TDocumentApprovingListRecordsEnumerator;
begin

  Result := TDocumentApprovingListRecordsEnumerator.Create(Self);
  
end;

function TDocumentApprovingListRecords.
  IsApprovingListRecordExistsForApprover(
    Approver: TEmployee
  ): Boolean;
begin

  Result := Assigned(FindApprovingListRecordForApprover(Approver));
  
end;

procedure TDocumentApprovingListRecords.RemoveApprovingListRecordForApprover(
  Approver: TEmployee);
var ApprovingListRecord: TDocumentApprovingListRecord;
begin

  ApprovingListRecord := FindApprovingListRecordForApprover(Approver);

  if Assigned(ApprovingListRecord) then
    DeleteDomainObjectValue(ApprovingListRecord);
  
end;

procedure TDocumentApprovingListRecords.SetDocumentApprovingListRecordByIndex(
  Index: Integer; DocumentApprovingListRecord: TDocumentApprovingListRecord);
begin

  SetDomainObjectValueByIndex(
    Index, DocumentApprovingListRecord
  );

end;

{ TDocumentApprovingList }

procedure TDocumentApprovingList.AddRecordFor(
  Approver: TEmployee;
  ApprovingPerformingResult: TDocumentApprovingPerformingResult
);
begin

  FRecords.Add(
    TDocumentApprovingListRecord.Create(
      Approver, ApprovingPerformingResult
    )
  );

end;

constructor TDocumentApprovingList.Create;
begin

  inherited;

  FRecords := TDocumentApprovingListRecords.Create;
  
end;

destructor TDocumentApprovingList.Destroy;
begin

  FreeAndNil(FRecords);
  
  inherited;

end;

function TDocumentApprovingList.
  IsRecordContainedForApprover(
    Approver: TEmployee
  ): Boolean;
begin

  Result := FRecords.IsApprovingListRecordExistsForApprover(Approver);

end;

procedure TDocumentApprovingList.RemoveRecordForApprover(Approver: TEmployee);
begin

  FRecords.RemoveApprovingListRecordForApprover(Approver);

end;

{ TDocumentApprovingListsEnumerator }

constructor TDocumentApprovingListsEnumerator.Create(
  DocumentApprovingLists: TDocumentApprovingLists);
begin

  inherited Create(DocumentApprovingLists);

end;

function TDocumentApprovingListsEnumerator.GetCurrentDocumentApprovingList: TDocumentApprovingList;
begin

  Result := TDocumentApprovingList(GetCurrentDomainObjectValue);
  
end;

{ TDocumentApprovingLists }

procedure TDocumentApprovingLists.Add(
  DocumentApprovingList: TDocumentApprovingList);
begin

  AddDomainObjectValue(DocumentApprovingList);

end;

function TDocumentApprovingLists.Contains(
  DocumentApprovingList: TDocumentApprovingList): Boolean;
begin

  Result := inherited Contains(DocumentApprovingList);

end;

function TDocumentApprovingLists.First: TDocumentApprovingList;
begin

  Result := TDocumentApprovingList(inherited First);

end;

function TDocumentApprovingLists.GetDocumentApprovingListByIndex(
  Index: Integer): TDocumentApprovingList;
begin

  Result := TDocumentApprovingList(GetDomainObjectValueByIndex(Index));

end;

function TDocumentApprovingLists.GetEnumerator: TDocumentApprovingListsEnumerator;
begin

  Result := TDocumentApprovingListsEnumerator.Create(Self);

end;

function TDocumentApprovingLists.Last: TDocumentApprovingList;
begin

  Result := TDocumentApprovingList(inherited Last);

end;

procedure TDocumentApprovingLists.Remove(
  DocumentApprovingList: TDocumentApprovingList);
begin

  DeleteDomainObjectValue(DocumentApprovingList);
  
end;

procedure TDocumentApprovingLists.SetDocumentApprovingListByIndex(
  Index: Integer; const Value: TDocumentApprovingList);
begin

  SetDomainObjectValueByIndex(Index, Value);

end;

end.
