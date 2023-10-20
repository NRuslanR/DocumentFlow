unit DocumentApprovingSheetViewModelMapper;

interface

uses

  DocumentApprovingSheetApprovingSetHolder,
  DocumentApprovingSheetViewModel,
  DocumentApprovingSheetDataDto,
  DataSetBuilder,
  DocumentFullInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DB,
  SysUtils;

type

  TDocumentApprovingSheetViewModelMapper = class

    protected

      FDataSetBuilder: IDataSetBuilder;
      
      function CreateAndFillApprovingSetHolderFrom(
        DocumentApprovingsDto: TDocumentApprovingsInfoDTO
      ): TDocumentApprovingSheetApprovingSetHolder;

      function CreateApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs; virtual;

      function CreateApprovingSet(
        ApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs
      ): TDataSet; virtual;

      procedure FillApprovingSetHolderFrom(
        ApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder;
        DocumentApprovingsDto: TDocumentApprovingsInfoDTO
      ); virtual;

    protected

      function MapApprovingPerformingStatusFrom(
        DocumentApprovingDto: TDocumentApprovingInfoDTO
      ): TDocumentApprovingPerformingStatus;

      function ToDocumentKindNameDativePadeg(const DocumentKindName: String): String;

    protected

      function CreateApproverShortNameFrom(ApproverDto: TDocumentFlowEmployeeInfoDTO): String;
      
    public

      constructor Create(DataSetBuilder: IDataSetBuilder);

      function MapDocumentApprovingSheetViewModelFrom(
        DocumentApprovingSheetDataDto: TDocumentApprovingSheetDataDto
      ): TDocumentApprovingSheetViewModel;

  end;

  TDocumentApprovingSheetViewModelMapperClass =
    class of TDocumentApprovingSheetViewModelMapper;
  
implementation

uses

  Variants,
  PadegImports,
  DateUtils;
  
{ TDocumentApprovingSheetViewModelMapper }

constructor TDocumentApprovingSheetViewModelMapper.Create(
  DataSetBuilder: IDataSetBuilder);
begin

  inherited Create;

  FDataSetBuilder := DataSetBuilder;

end;

function TDocumentApprovingSheetViewModelMapper.MapApprovingPerformingStatusFrom(
  DocumentApprovingDto: TDocumentApprovingInfoDTO
): TDocumentApprovingPerformingStatus;
begin

  if DocumentApprovingDto.PerformingResultServiceName = 'approved' then
  begin

      if DocumentApprovingDto.Note <> '' then
        Result := DocumentApprovingSheetApprovingSetHolder.prApprovedWithNotes

      else Result := DocumentApprovingSheetApprovingSetHolder.prApproved;

  end;

  if DocumentApprovingDto.PerformingResultServiceName = 'not_approved' then
    Result := DocumentApprovingSheetApprovingSetHolder.prNotApproved

  else if DocumentApprovingDto.PerformingResultServiceName = 'not_performed' then
    Result := DocumentApprovingSheetApprovingSetHolder.prOnApproving;
    
end;

function TDocumentApprovingSheetViewModelMapper.MapDocumentApprovingSheetViewModelFrom(
  DocumentApprovingSheetDataDto: TDocumentApprovingSheetDataDto
): TDocumentApprovingSheetViewModel;
begin

  Result := TDocumentApprovingSheetViewModel.Create;

  try

    Result.DocumentKindName := ToDocumentKindNameDativePadeg(DocumentApprovingSheetDataDto.DocumentDto.Kind);
    Result.DocumentName := DocumentApprovingSheetDataDto.DocumentDto.Name;
    Result.ApprovingSetHolder := CreateAndFillApprovingSetHolderFrom(DocumentApprovingSheetDataDto.DocumentApprovingsDto);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentApprovingSheetViewModelMapper.
  ToDocumentKindNameDativePadeg(const DocumentKindName: String): String;
var
    DocumentKindNameDativePadeg: PChar;
    DocumentKindNameDativePadegLen: LongInt;
begin

  DocumentKindNameDativePadegLen := Length(DocumentKindName) + 10;

  DocumentKindNameDativePadeg := StrAlloc(DocumentKindNameDativePadegLen);

  try

    if
      GetAppointmentPadeg(
        PChar(DocumentKindName),
        3,
        DocumentKindNameDativePadeg,
        DocumentKindNameDativePadegLen
      ) = 0
    then
      Result := String(DocumentKindNameDativePadeg)

    else Result := DocumentKindName;

  finally

    StrDispose(DocumentKindNameDativePadeg);
    
  end;

end;

function TDocumentApprovingSheetViewModelMapper.CreateAndFillApprovingSetHolderFrom(
  DocumentApprovingsDto: TDocumentApprovingsInfoDTO
): TDocumentApprovingSheetApprovingSetHolder;
begin

  Result := TDocumentApprovingSheetApprovingSetHolder.Create;

  try

    Result.FieldDefs := CreateApprovingSetFieldDefs;
    Result.DataSet := CreateApprovingSet(Result.FieldDefs);

    FillApprovingSetHolderFrom(Result, DocumentApprovingsDto);
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentApprovingSheetViewModelMapper.
  CreateApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs;
begin

  Result := TDocumentApprovingSheetApprovingSetFieldDefs.Create;

  with Result do begin

    ApproverSpecialityFieldName := 'approver_speciality';
    ApprovingPerformingStatusFieldName := 'approving_performing_status';
    ApprovingPerformingStatusNameFieldName := 'approving_performing_status_name';
    ApprovingPerformingDateFieldName := 'approving_performing_date';
    IsApprovedWithNotesFieldName := 'is_approved_with_notes';
    ApproverNameFieldName := 'approver_name';
    NoteFieldName := 'note';
    
  end;
  
end;

function TDocumentApprovingSheetViewModelMapper.CreateApproverShortNameFrom(
  ApproverDto: TDocumentFlowEmployeeInfoDTO): String;
begin

  Result :=
    UpperCase(String(ApproverDto.Name[1])) + '. ' +
    UpperCase(String(ApproverDto.Patronymic[1])) + '. ' +
    ApproverDto.Surname;
    
end;

function TDocumentApprovingSheetViewModelMapper.CreateApprovingSet(
  ApprovingSetFieldDefs: TDocumentApprovingSheetApprovingSetFieldDefs
): TDataSet;
begin

  with ApprovingSetFieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(ApproverSpecialityFieldName, ftString, 500)
        .AddField(ApprovingPerformingStatusFieldName, ftInteger)
        .AddField(ApprovingPerformingStatusNameFieldName, ftString, 50)
        .AddField(ApprovingPerformingDateFieldName, ftDate)
        .AddField(ApproverNameFieldName, ftString, 300)
        .AddField(NoteFieldName, ftString, 500)
        .AddField(IsApprovedWithNotesFieldName, ftBoolean)
        .Build;
        
  end;

end;

procedure TDocumentApprovingSheetViewModelMapper.FillApprovingSetHolderFrom(
  ApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder;
  DocumentApprovingsDto: TDocumentApprovingsInfoDTO
);
var
    DocumentApprovingDto: TDocumentApprovingInfoDTO;
    ApprovingPerformingStatus: DocumentApprovingSheetApprovingSetHolder.TDocumentApprovingPerformingStatus;
begin

  if not ApprovingSetHolder.DataSet.Active then
    ApprovingSetHolder.DataSet.Active;

  for DocumentApprovingDto in DocumentApprovingsDto do begin

    with ApprovingSetHolder, DocumentApprovingDto do begin

      Append;

      ApproverSpecialityFieldValue := ApproverInfoDTO.Speciality;

      if not VarIsNull(PerformingDateTime) and (PerformingDateTime <> 0) then
        ApprovingPerformingDateFieldValue := DateOf(PerformingDateTime);
        
      ApprovingPerformingStatus := MapApprovingPerformingStatusFrom(DocumentApprovingDto);

      ApprovingPerformingStatusFieldValue := ApprovingPerformingStatus;

      IsApprovedWithNotesFieldValue := ApprovingPerformingStatus = prApprovedWithNotes;
      
      if ApprovingPerformingStatus = prApprovedWithNotes then
        ApprovingPerformingStatusNameFieldValue := 'Согласовано с замечаниями'

      else if ApprovingPerformingStatusFieldValue = prOnApproving then
        ApprovingPerformingStatusNameFieldValue := 'На согласовании'

      else ApprovingPerformingStatusNameFieldValue := PerformingResultName;

      ApproverNameFieldValue := CreateApproverShortNameFrom(ApproverInfoDTO);

      NoteFieldValue := Note;

      Post;

    end;

  end;

  ApprovingSetHolder.First;

end;

end.
