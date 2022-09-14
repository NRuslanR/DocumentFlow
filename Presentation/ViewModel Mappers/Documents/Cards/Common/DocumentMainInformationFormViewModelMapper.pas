unit DocumentMainInformationFormViewModelMapper;

interface

uses

  DocumentResponsibleInfoDTO,
  ChangedDocumentInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentResponsibleViewModelMapper,
  DocumentSignerViewModelMapper,
  DocumentResponsibleViewModelUnit,
  DocumentSignerViewModelUnit,
  DocumentMainInformationFormViewModelUnit,
  DocumentFullInfoDTO,
  NewDocumentInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentMainInformationFormViewModelMapper = class

    protected

      FDocumentResponsibleViewModelMapper: TDocumentResponsibleViewModelMapper;
      FDocumentSignerViewModelMapper: TDocumentSignerViewModelMapper;

      function CreateDocumentResponsibleViewModelMapper:
        TDocumentResponsibleViewModelMapper; virtual;

      function CreateDocumentSignerViewModelMapper:
        TDocumentSignerViewModelMapper; virtual;

    protected

      function CreateDocumentMainInformationFormViewModelInstance:
        TDocumentMainInformationFormViewModel; virtual;

      procedure FillDocumentMainInformationFormViewModel(
        ViewModel: TDocumentMainInformationFormViewModel;
        DocumentDTO: TDocumentDTO
      ); virtual;

      procedure FillNewDocumentDTOByViewModel(
        DocumentDTO: TDocumentDTO;
        ViewModel: TDocumentMainInformationFormViewModel
      ); virtual;

      procedure FillChangedDocumentDTOByViewModel(
        ChangedDocumentDTO: TChangedDocumentDTO;
        ViewModel: TDocumentMainInformationFormViewModel
      ); virtual;

    protected

      function CreateChangedDocumentDTOInstance: TChangedDocumentDTO; virtual;
      function CreateNewDocumentDTOInstance: TDocumentDTO; virtual;

    protected

      function MapDocumentResponsibleViewModelFrom(
        DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
      ): TDocumentResponsibleViewModel; virtual;

      function MapDocumentResponsibleViewModelTo(
        DocumentResponsibleViewModel: TDocumentResponsibleViewModel
      ): TDocumentResponsibleInfoDTO; virtual;

    protected
    
      function MapDocumentSignerViewModelFrom(
        DocumentSigningInfoDTO: TDocumentSigningInfoDTO
      ): TDocumentSignerViewModel; virtual;

      function MapDocumentSignerViewModelTo(
        DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
      ): TDocumentSigningInfoDTO; virtual;

    public

      destructor Destroy; override;
      constructor Create;

      function MapDocumentMainInformationFormViewModelFrom(
        DocumentDTO: TDocumentDTO
      ): TDocumentMainInformationFormViewModel; virtual;

      function MapDocumentMainInformationFormViewModelToChangedDocumentDTO(
        DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
      ): TChangedDocumentDTO; virtual;

      function MapDocumentMainInformationFormViewModelToNewDocumentDTO(
        DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
      ): TDocumentDTO; virtual;

      function CreateEmptyDocumentMainInformationFormViewModel:
        TDocumentMainInformationFormViewModel; virtual;

    public

      property DocumentResponsibleViewModelMapper: TDocumentResponsibleViewModelMapper
      read FDocumentResponsibleViewModelMapper;
      
      property DocumentSignerViewModelMapper: TDocumentSignerViewModelMapper
      read FDocumentSignerViewModelMapper;
      
  end;


implementation

uses

  Variants,
  StrUtils;

{ TDocumentMainInformationFormViewModelMapper }

constructor TDocumentMainInformationFormViewModelMapper.Create;
begin

  inherited;

  FDocumentResponsibleViewModelMapper := CreateDocumentResponsibleViewModelMapper;
  FDocumentSignerViewModelMapper := CreateDocumentSignerViewModelMapper;
  
end;

function TDocumentMainInformationFormViewModelMapper.CreateChangedDocumentDTOInstance: TChangedDocumentDTO;
begin

  Result := TChangedDocumentDTO.Create;
  
end;

function TDocumentMainInformationFormViewModelMapper.
  CreateDocumentMainInformationFormViewModelInstance:
    TDocumentMainInformationFormViewModel;
begin

  Result := TDocumentMainInformationFormViewModel.Create;

end;

function TDocumentMainInformationFormViewModelMapper.CreateDocumentResponsibleViewModelMapper: TDocumentResponsibleViewModelMapper;
begin

  Result := TDocumentResponsibleViewModelMapper.Create;
  
end;

function TDocumentMainInformationFormViewModelMapper.CreateDocumentSignerViewModelMapper: TDocumentSignerViewModelMapper;
begin

  Result := TDocumentSignerViewModelMapper.Create;
  
end;

function TDocumentMainInformationFormViewModelMapper.CreateEmptyDocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel;
begin

  Result := CreateDocumentMainInformationFormViewModelInstance;
  
end;

function TDocumentMainInformationFormViewModelMapper.CreateNewDocumentDTOInstance: TDocumentDTO;
begin

  Result := TDocumentDTO.Create;
  
end;

destructor TDocumentMainInformationFormViewModelMapper.Destroy;
begin

  FreeAndNil(FDocumentResponsibleViewModelMapper);
  FreeAndNil(FDocumentSignerViewModelMapper);
  
  inherited;

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentMainInformationFormViewModelFrom(
    DocumentDTO: TDocumentDTO
  ): TDocumentMainInformationFormViewModel;
begin

  Result := CreateDocumentMainInformationFormViewModelInstance;

  FillDocumentMainInformationFormViewModel(Result, DocumentDTO);

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentMainInformationFormViewModelToChangedDocumentDTO(
    DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
  ): TChangedDocumentDTO;
begin

  Result := CreateChangedDocumentDTOInstance;

  try

    FillChangedDocumentDTOByViewModel(Result, DocumentMainInformationFormViewModel);
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentMainInformationFormViewModelToNewDocumentDTO(
  DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
): TDocumentDTO;
var DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  Result := CreateNewDocumentDTOInstance;

  try

    FillNewDocumentDTOByViewModel(Result, DocumentMainInformationFormViewModel);

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

procedure TDocumentMainInformationFormViewModelMapper.FillNewDocumentDTOByViewModel(
  DocumentDTO: TDocumentDTO;
  ViewModel: TDocumentMainInformationFormViewModel
);
var
    DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  DocumentDTO.Id := ViewModel.DocumentId;
  DocumentDTO.ProductCode := ViewModel.ProductCode;
  DocumentDTO.BaseDocumentId := ViewModel.BaseDocumentId;
  DocumentDTO.Number := ViewModel.Number;
  DocumentDTO.Name := ViewModel.Name;
  DocumentDTO.Content := ViewModel.Content;
  DocumentDTO.CreationDate := ViewModel.CreationDate;
  DocumentDTO.DocumentDate := ViewModel.DocumentDate;
  DocumentDTO.Note := ViewModel.Note;
  DocumentDTO.IsSelfRegistered := ViewModel.IsSelfRegistered;
  DocumentDTO.CurrentWorkCycleStageNumber := ViewModel.CurrentWorkCycleStageNumber;
  DocumentDTO.CurrentWorkCycleStageName := ViewModel.CurrentWorkCycleStageName;

  DocumentDTO.SigningsInfoDTO := TDocumentSigningsInfoDTO.Create;

  DocumentSigningInfoDTO := MapDocumentSignerViewModelTo(ViewModel);

  DocumentDTO.SigningsInfoDTO.Add(DocumentSigningInfoDTO);

  DocumentDTO.ResponsibleInfoDTO :=
    MapDocumentResponsibleViewModelTo(ViewModel.DocumentResponsibleViewModel);

  DocumentDTO.AuthorDTO := TDocumentFlowEmployeeInfoDTO.Create;

  DocumentDTO.AuthorDTO.Id := ViewModel.DocumentAuthorIdentity;
  DocumentDTO.AuthorDTO.FullName := ViewModel.DocumentAuthorShortFullName;

end;

procedure TDocumentMainInformationFormViewModelMapper.
  FillChangedDocumentDTOByViewModel(
    ChangedDocumentDTO: TChangedDocumentDTO;
    ViewModel: TDocumentMainInformationFormViewModel
  );
var
    DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  ChangedDocumentDTO.Id := ViewModel.DocumentId;
  ChangedDocumentDTO.ProductCode := ViewModel.ProductCode;
  ChangedDocumentDTO.BaseDocumentId := ViewModel.BaseDocumentId;
  ChangedDocumentDTO.Number := ViewModel.Number;
  ChangedDocumentDTO.Name := ViewModel.Name;
  ChangedDocumentDTO.Content := ViewModel.Content;
  ChangedDocumentDTO.CreationDate := ViewModel.CreationDate;
  ChangedDocumentDTO.DocumentDate := ViewModel.DocumentDate;
  ChangedDocumentDTO.Note := ViewModel.Note;
  ChangedDocumentDTO.IsSelfRegistered := ViewModel.IsSelfRegistered;
  ChangedDocumentDTO.CurrentWorkCycleStageNumber := ViewModel.CurrentWorkCycleStageNumber;
  ChangedDocumentDTO.CurrentWorkCycleStageName := ViewModel.CurrentWorkCycleStageName;

  ChangedDocumentDTO.SigningsInfoDTO := TDocumentSigningsInfoDTO.Create;

  DocumentSigningInfoDTO := MapDocumentSignerViewModelTo(ViewModel);

  ChangedDocumentDTO.SigningsInfoDTO.Add(DocumentSigningInfoDTO);

  ChangedDocumentDTO.ResponsibleInfoDTO :=
    MapDocumentResponsibleViewModelTo(ViewModel.DocumentResponsibleViewModel);
    
end;

procedure TDocumentMainInformationFormViewModelMapper.FillDocumentMainInformationFormViewModel(
  ViewModel: TDocumentMainInformationFormViewModel;
  DocumentDTO: TDocumentDTO
);
var
    DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  ViewModel.DocumentId := DocumentDTO.Id;
  ViewModel.ProductCode := DocumentDTO.ProductCode;
  ViewModel.BaseDocumentId := DocumentDTO.BaseDocumentId;
  ViewModel.DocumentAuthorIdentity := DocumentDTO.AuthorDTO.Id;
  ViewModel.DocumentAuthorShortFullName := DocumentDTO.AuthorDTO.FullName;
  ViewModel.Kind := DocumentDTO.Kind;
  ViewModel.KindId := DocumentDTO.KindId;

  { refactor: получать из dto prefix, main value }
  
  ViewModel.NumberPartsSeparator := DocumentDTO.SeparatorOfNumberParts;

  ViewModel.Number := DocumentDTO.Number;
  
  ViewModel.CreationDate := DocumentDTO.CreationDate;
  ViewModel.DocumentDate := DocumentDTO.DocumentDate;
  ViewModel.Name := DocumentDTO.Name;
  ViewModel.Content := DocumentDTO.Content;
  ViewModel.Note := DocumentDTO.Note;
  ViewModel.IsSelfRegistered := DocumentDTO.IsSelfRegistered;
  ViewModel.CurrentWorkCycleStageNumber := DocumentDTO.CurrentWorkCycleStageNumber;
  ViewModel.CurrentWorkCycleStageName := DocumentDTO.CurrentWorkCycleStageName;

  if Assigned(DocumentDTO.SigningsInfoDTO) and
     (DocumentDTO.SigningsInfoDTO.Count > 0)
  then begin

    if DocumentDTO.SigningsInfoDTO.Count > 1 then begin
    
      raise Exception.Create(
        'Отображение модели представления ' +
        'формы основных сведений о документе ' +
        'для нескольких подписантов не ' +
        'поддерживается на данный момент'
      );

    end;

    DocumentSigningInfoDTO := DocumentDTO.SigningsInfoDTO[0];

    if not VarIsNull(DocumentSigningInfoDTO.SigningDate) then
      ViewModel.SigningDate := DocumentSigningInfoDTO.SigningDate;

    if Assigned(DocumentSigningInfoDTO.ActuallySignedEmployeeInfoDTO)
    then begin
    
      ViewModel.ActualSignerName :=
        DocumentSigningInfoDTO.ActuallySignedEmployeeInfoDTO.FullName;

    end;

    ViewModel.DocumentSignerViewModel :=
      MapDocumentSignerViewModelFrom(DocumentSigningInfoDTO);

  end;

  if Assigned(DocumentDTO.ResponsibleInfoDTO) then
    ViewModel.DocumentResponsibleViewModel :=
      MapDocumentResponsibleViewModelFrom(DocumentDTO.ResponsibleInfoDTO);

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentResponsibleViewModelFrom(
    DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
  ): TDocumentResponsibleViewModel;
begin

  Result :=
    FDocumentResponsibleViewModelMapper.MapDocumentResponsibleViewModelFrom(
      DocumentResponsibleInfoDTO
    );
    
end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentSignerViewModelFrom(
    DocumentSigningInfoDTO: TDocumentSigningInfoDTO
  ): TDocumentSignerViewModel;
begin

  Result :=
    FDocumentSignerViewModelMapper.MapDocumentSignerViewModelFrom(
      DocumentSigningInfoDTO.SignerInfoDTO
    );

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentResponsibleViewModelTo(
    DocumentResponsibleViewModel: TDocumentResponsibleViewModel
  ): TDocumentResponsibleInfoDTO;
begin

  if not Assigned(DocumentResponsibleViewModel) then begin

    Result := nil;
    Exit;

  end;

  { refactor: перенести в DocumentResponsibleViewModelMapper }
  
  Result := TDocumentResponsibleInfoDTO.Create;

  Result.Id := DocumentResponsibleViewModel.Id;
  Result.Name := DocumentResponsibleViewModel.Name;
  Result.TelephoneNumber := DocumentResponsibleViewModel.TelephoneNumber;

  Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
  Result.DepartmentInfoDTO.Name := DocumentResponsibleViewModel.DepartmentShortName;
  Result.DepartmentInfoDTO.Code := DocumentResponsibleViewModel.DepartmentCode;

end;

function TDocumentMainInformationFormViewModelMapper.
  MapDocumentSignerViewModelTo(
    DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
  ): TDocumentSigningInfoDTO;
var DocumentSignerViewModel: TDocumentSignerViewModel;
begin

  if not Assigned(DocumentMainInformationFormViewModel.DocumentSignerViewModel) then
  begin

    Result := nil;
    Exit;
    
  end;

  DocumentSignerViewModel :=
    DocumentMainInformationFormViewModel.DocumentSignerViewModel;
    
  Result := TDocumentSigningInfoDTO.Create;

  try

    { refactor: перенести в DocumentSignerViewModelMapper }
    
    Result.SigningDate := DocumentMainInformationFormViewModel.SigningDate;

    Result.SignerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
    Result.SignerInfoDTO.Id := DocumentSignerViewModel.Id;
    Result.SignerInfoDTO.FullName := DocumentSignerViewModel.Name;
    Result.SignerInfoDTO.Speciality := DocumentSignerViewModel.Speciality;

    Result.SignerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

    Result.SignerInfoDTO.DepartmentInfoDTO.Name :=
      DocumentSignerViewModel.DepartmentShortName;

    Result.SignerInfoDTO.DepartmentInfoDTO.Code :=
      DocumentSignerViewModel.DepartmentCode;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

end.
