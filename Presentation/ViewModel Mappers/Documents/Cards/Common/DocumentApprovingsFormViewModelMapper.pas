unit DocumentApprovingsFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentApprovingCycleSetHolder,
  AbstractDataSetHolder,
  DocumentApprovingCycleViewModel,
  DocumentApprovingCycleDTO,
  DocumentApprovingsFormViewModel,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentApprovingsFormViewModelMapper = class

    private

    protected

      function CreateDocumentApprovingsFormViewModelInstance: TDocumentApprovingsFormViewModel; virtual;
      
      procedure FillDocumentApprovingCycleSetHolderBy(

        DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;

        DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
        DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      );

      procedure AppendRecordToDocumentApprovingSetHolderFrom(
        DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
        DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
        const ApprovingCycleId: Variant;
        const IsApprovingNew: Boolean
      );

      function MapDocumentApprovingSetHolderTo(
        DocumentApprovingSetHolder: TDocumentApprovingSetHolder
      ): TDocumentApprovingInfoDTO;
      
    public

      function MapDocumentApprovingCycleViewModelFrom(
        DocumentApprovingCycleDTO: TDocumentApprovingCycleDTO
      ): TDocumentApprovingCycleViewModel; virtual;
      
      function MapDocumentApprovingsFormViewModelFrom(

        DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
        DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
      
        DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder

      ): TDocumentApprovingsFormViewModel; virtual;

      function MapDocumentApprovingsFormViewModelTo(

        DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel

      ): TDocumentApprovingsInfoDTO; virtual;

      function CreateNewDocumentApprovingCycleViewModel:
        TDocumentApprovingCycleViewModel;
        
      function CreateEmptyDocumentApprovingsFormViewModel(
        DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder
      ): TDocumentApprovingsFormViewModel; virtual;
      
  end;
  
implementation

uses

  Variants;

{ TDocumentApprovingsFormViewModelMapper }

function TDocumentApprovingsFormViewModelMapper.
  MapDocumentApprovingCycleViewModelFrom(
    DocumentApprovingCycleDTO: TDocumentApprovingCycleDTO
  ): TDocumentApprovingCycleViewModel;
begin

  Result := TDocumentApprovingCycleViewModel.CreateFrom(
              DocumentApprovingCycleDTO.Id,
              DocumentApprovingCycleDTO.Number,
              'Цикл ' + IntToStr(DocumentApprovingCycleDTO.Number),
              True
            );
            
end;

function TDocumentApprovingsFormViewModelMapper.
  MapDocumentApprovingSetHolderTo(
    DocumentApprovingSetHolder: TDocumentApprovingSetHolder
  ): TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO.Create;
  
  try

    with DocumentApprovingSetHolder do begin

      Result.Id := IdFieldValue;
      Result.TopLevelApprovingId := TopLevelApprovingIdFieldValue;
      Result.PerformingDateTime := PerformingDateTimeFieldValue;

      if not VarIsNull(PerformingResultIdFieldValue) then
        Result.PerformingResult := PerformingResultIdFieldValue;
        
      Result.PerformingResultName := PerformingResultFieldValue;
      Result.Note := NoteFieldValue;
      Result.IsViewedByApprover := IsViewedByPerformerFieldValue;

      Result.ApproverInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.ApproverInfoDTO.Id := PerformerIdFieldValue;
                                            
      Result.ApproverInfoDTO.FullName := PerformerNameFieldValue;

      Result.ApproverInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.ApproverInfoDTO.DepartmentInfoDTO.Name :=
        PerformerDepartmentNameFieldValue;

      if not VarIsNull(ActuallyPerformedEmployeeIdFieldValue) then begin

        Result.ActuallyPerformedEmployeeInfoDTO :=
          TDocumentFlowEmployeeInfoDTO.Create;

        Result.ActuallyPerformedEmployeeInfoDTO.Id :=
          ActuallyPerformedEmployeeIdFieldValue;

        Result.ActuallyPerformedEmployeeInfoDTO.FullName :=
          ActuallyPerformedEmployeeNameFieldValue;
            
      end;

    end;
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentApprovingsFormViewModelMapper.
  MapDocumentApprovingsFormViewModelFrom(

    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
    DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
    DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;

    DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder

  ): TDocumentApprovingsFormViewModel;
begin

  FillDocumentApprovingCycleSetHolderBy(
    DocumentApprovingCycleSetHolder,

    DocumentApprovingsInfoDTO,
    DocumentApprovingCycleResultsInfoDTO,
    DocumentUsageEmployeeAccessRightsInfoDTO
  );

  Result := CreateDocumentApprovingsFormViewModelInstance;

  Result.DocumentApprovingCycleSetHolder :=
    DocumentApprovingCycleSetHolder;
            
end;

procedure TDocumentApprovingsFormViewModelMapper.
  AppendRecordToDocumentApprovingSetHolderFrom(
    DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    const ApprovingCycleId: Variant;
    const IsApprovingNew: Boolean
  );
begin

  DocumentApprovingSetHolder.Append;
  
  DocumentApprovingSetHolder.IdFieldValue :=
    DocumentApprovingInfoDTO.Id;

  DocumentApprovingSetHolder.IsNewFieldValue := IsApprovingNew;
  
  DocumentApprovingSetHolder.TopLevelApprovingIdFieldValue :=
    DocumentApprovingInfoDTO.TopLevelApprovingId;
  
  DocumentApprovingSetHolder.PerformerIdFieldValue :=
    DocumentApprovingInfoDTO.ApproverInfoDTO.Id;

  DocumentApprovingSetHolder.IsApprovingAccessibleFieldValue :=
    DocumentApprovingInfoDTO.IsAccessible;

  DocumentApprovingSetHolder.PerformerNameFieldValue :=
    DocumentApprovingInfoDTO.ApproverInfoDTO.FullName;

  DocumentApprovingSetHolder.PerformerSpecialityFieldValue :=
    DocumentApprovingInfoDTO.ApproverInfoDTO.Speciality;

  DocumentApprovingSetHolder.PerformerDepartmentNameFieldValue :=
    DocumentApprovingInfoDTO.ApproverInfoDTO.DepartmentInfoDTO.Name;

  if Assigned(DocumentApprovingInfoDTO.ActuallyPerformedEmployeeInfoDTO) then
  begin

    DocumentApprovingSetHolder.ActuallyPerformedEmployeeIdFieldValue :=
      DocumentApprovingInfoDTO.ActuallyPerformedEmployeeInfoDTO.Id;

    DocumentApprovingSetHolder.ActuallyPerformedEmployeeNameFieldValue :=
      DocumentApprovingInfoDTO.ActuallyPerformedEmployeeInfoDTO.FullName;

  end;
  
  DocumentApprovingSetHolder.PerformingResultIdFieldValue :=
    DocumentApprovingInfoDTO.PerformingResult;

  DocumentApprovingSetHolder.PerformingResultFieldValue :=
    DocumentApprovingInfoDTO.PerformingResultName;

  DocumentApprovingSetHolder.PerformingDateTimeFieldValue :=
    DocumentApprovingInfoDTO.PerformingDateTime;

  DocumentApprovingSetHolder.NoteFieldValue :=
    DocumentApprovingInfoDTO.Note;

  DocumentApprovingSetHolder.IsViewedByPerformerFieldValue :=
    DocumentApprovingInfoDTO.IsViewedByApprover;

  DocumentApprovingSetHolder.ApprovingCycleIdFieldValue :=
    ApprovingCycleId;

  DocumentApprovingSetHolder.Post;

end;

function TDocumentApprovingsFormViewModelMapper.
  CreateDocumentApprovingsFormViewModelInstance: TDocumentApprovingsFormViewModel;
begin

  Result := TDocumentApprovingsFormViewModel.Create;
  
end;

function TDocumentApprovingsFormViewModelMapper.
  CreateEmptyDocumentApprovingsFormViewModel(
    DocumentApprovingCycleSetHolder:
      TDocumentApprovingCycleSetHolder
  ): TDocumentApprovingsFormViewModel;
begin

  Result := CreateDocumentApprovingsFormViewModelInstance;

  Result.DocumentApprovingCycleSetHolder :=
    DocumentApprovingCycleSetHolder;

end;

function TDocumentApprovingsFormViewModelMapper.
  CreateNewDocumentApprovingCycleViewModel:
    TDocumentApprovingCycleViewModel;
begin

  Result :=
    TDocumentApprovingCycleViewModel.CreateFrom(
      Null, 1, 'Цикл 1', True
    );

end;

{ refactor:
  пересмотреть логику этого метода
  в связи с пересмотром самой реализации
  механизма согласования документов }
procedure TDocumentApprovingsFormViewModelMapper.
  FillDocumentApprovingCycleSetHolderBy(
    DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;

    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
    DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
    DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
  );
var DocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO;
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
    MaxApprovingCycleNumber: Integer;
begin

  MaxApprovingCycleNumber := -1;

  DocumentApprovingSetHolder :=
    DocumentApprovingCycleSetHolder.DocumentApprovingSetHolder;

  if Assigned(DocumentApprovingCycleResultsInfoDTO) then begin

    for DocumentApprovingCycleResultInfoDTO in
        DocumentApprovingCycleResultsInfoDTO
    do
    begin

      DocumentApprovingCycleSetHolder.Append;

      DocumentApprovingCycleSetHolder.IdFieldValue :=
        DocumentApprovingCycleResultInfoDTO.Id;

      DocumentApprovingCycleSetHolder.CycleNumberFieldValue :=
        DocumentApprovingCycleResultInfoDTO.CycleNumber;

      DocumentApprovingCycleSetHolder.CycleNameFieldValue :=
        'Цикл ' +
        IntToStr(DocumentApprovingCycleResultInfoDTO.CycleNumber);

      DocumentApprovingCycleSetHolder.IsCycleNewFieldValue :=
        False;

      DocumentApprovingCycleSetHolder.CanBeCompletedFieldValue := False;
        
      if MaxApprovingCycleNumber < DocumentApprovingCycleResultInfoDTO.CycleNumber
      then
        MaxApprovingCycleNumber :=
          DocumentApprovingCycleResultInfoDTO.CycleNumber;

      DocumentApprovingCycleSetHolder.Post;

      for DocumentApprovingInfoDTO in
          DocumentApprovingCycleResultInfoDTO.DocumentApprovingsInfoDTO
      do
      begin

        AppendRecordToDocumentApprovingSetHolderFrom(
          DocumentApprovingSetHolder,
          DocumentApprovingInfoDTO,
          DocumentApprovingCycleResultInfoDTO.Id,
          False
        );

      end;

    end;

  end;

  if Assigned(DocumentApprovingsInfoDTO) and
     (DocumentApprovingsInfoDTO.Count > 0)
  then begin

    if MaxApprovingCycleNumber = -1 then
      MaxApprovingCycleNumber := 1

    else Inc(MaxApprovingCycleNumber);

    DocumentApprovingCycleSetHolder.Append;

    DocumentApprovingCycleSetHolder.IdFieldValue :=
      MaxApprovingCycleNumber;

    DocumentApprovingCycleSetHolder.CycleNumberFieldValue :=
      MaxApprovingCycleNumber;

    DocumentApprovingCycleSetHolder.CycleNameFieldValue :=
      'Цикл ' +
      IntToStr(MaxApprovingCycleNumber);

    DocumentApprovingCycleSetHolder.IsCycleNewFieldValue := True;

    DocumentApprovingCycleSetHolder.CanBeCompletedFieldValue :=
      DocumentUsageEmployeeAccessRightsInfoDTO.DocumentApprovingCanBeCompleted;

    DocumentApprovingCycleSetHolder.Post;
    
    for DocumentApprovingInfoDTO in DocumentApprovingsInfoDTO do begin

      AppendRecordToDocumentApprovingSetHolderFrom(
        DocumentApprovingSetHolder,
        DocumentApprovingInfoDTO,
        MaxApprovingCycleNumber,
        True
      );

    end;
    
  end;
    
end;

function TDocumentApprovingsFormViewModelMapper.
  MapDocumentApprovingsFormViewModelTo(

    DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel

  ): TDocumentApprovingsInfoDTO;
var DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
    DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
    PreviousFilter: String;
begin

  Result := TDocumentApprovingsInfoDTO.Create;
  
  DocumentApprovingCycleSetHolder :=
    DocumentApprovingsFormViewModel.DocumentApprovingCycleSetHolder;

  DocumentApprovingCycleSetHolder.DisableControls;
  
  if not DocumentApprovingCycleSetHolder.LocateNewApprovingCycleRecord
  then begin

    DocumentApprovingCycleSetHolder.EnableControls;
    Exit;

  end;

  DocumentApprovingSetHolder :=
    DocumentApprovingsFormViewModel.DocumentApprovingSetHolder;

  try

    PreviousFilter :=
      DocumentApprovingSetHolder.DocumentApprovingSet.Filter;
      
    DocumentApprovingSetHolder.FilterByCycleId(
      DocumentApprovingCycleSetHolder.IdFieldValue,
      famDisableControls
    );
    
    with DocumentApprovingSetHolder do begin

      First;

      while not Eof do begin

        Result.Add(
          MapDocumentApprovingSetHolderTo(
            DocumentApprovingSetHolder
          )
        );

        Next;
        
      end;

    end;

    if PreviousFilter = '' then
      DocumentApprovingSetHolder.ResetFilter(frmEnableControls)

    else begin

      DocumentApprovingSetHolder.ApplyFilter(
        PreviousFilter, famNotDisableControls
      );

    end;
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      if PreviousFilter = '' then
        DocumentApprovingSetHolder.ResetFilter(frmEnableControls)

      else begin
      
        DocumentApprovingSetHolder.ApplyFilter(
          PreviousFilter, famNotDisableControls
        );

      end;

      raise;
      
    end;

  end;
  
end;

end.
