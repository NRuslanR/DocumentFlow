unit DocumentDTOFromDataSetMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  VariantListUnit,
  DocumentInfoHolder,
  DocumentFlowEmployeeInfoDTOMapper,
  Disposable,
  SysUtils;

type

  TDocumentDTOFromDataSetMapper = class (TInterfacedObject, IDisposable)

    protected

      function MapDocumentAuthorInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
      function MapDocumentResponsibleInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentResponsibleInfoDTO;

    protected

      function MapDocumentSigningsInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentSigningsInfoDTO;
      function MapDocumentSigningInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentSigningInfoDTO;

    protected

      function MapDocumentSignerInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
      function MapDocumentActuallySignedEmployeeInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
  
    protected

      function CreateDocumentSigningsInfoDTOInstance: TDocumentSigningsInfoDTO; virtual;
      function CreateDocumentSigningInfoDTOInstance: TDocumentSigningInfoDTO; virtual;
      function CreateDocumentDTOInstance: TDocumentDTO; virtual;

    public

      function MapDocumentDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO; virtual;

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  Variants;

{ TDocumentDTOFromDataSetMapper }

function TDocumentDTOFromDataSetMapper.MapDocumentDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO;
begin

  Result := CreateDocumentDTOInstance;

  try

    with Result, DocumentInfoHolder do begin

      First;

      Id := IdFieldValue;
      BaseDocumentId := BaseIdFieldValue;
      Number := NumberFieldValue;
      SeparatorOfNumberParts := '/';
      Name := NameFieldValue;
      FullName := FullNameFieldValue;
      ProductCode := ProductCodeFieldValue;
      Content := ContentFieldValue;
      CreationDate := CreationDateFieldValue;
      DocumentDate := DateFieldValue;
      Note := NoteFieldValue;
      IsSelfRegistered := IsSelfRegisteredFieldValue;
      Kind := KindFieldValue;
      KindId := KindIdFieldValue;
      CurrentWorkCycleStageNumber := CurrentWorkCycleStageNumberFieldValue;
      CurrentWorkCycleStageName := CurrentWorkCycleStageNameFieldValue;
      AuthorDTO := MapDocumentAuthorInfoDTOFrom(DocumentInfoHolder);
      ResponsibleInfoDTO := MapDocumentResponsibleInfoDTOFrom(DocumentInfoHolder);
      SigningsInfoDTO := MapDocumentSigningsInfoDTOFrom(DocumentInfoHolder);

    end;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentDTOFromDataSetMapper.CreateDocumentDTOInstance: TDocumentDTO;
begin

  Result := TDocumentDTO.Create;
  
end;

function TDocumentDTOFromDataSetMapper.CreateDocumentSigningInfoDTOInstance: TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO.Create;

end;

function TDocumentDTOFromDataSetMapper.CreateDocumentSigningsInfoDTOInstance: TDocumentSigningsInfoDTO;
begin

  Result := TDocumentSigningsInfoDTO.Create;

end;

function TDocumentDTOFromDataSetMapper.MapDocumentAuthorInfoDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentInfoHolder do begin

      Result.Id := AuthorIdFieldValue;

      if not VarIsNull(Result.Id) then begin

        Result.LeaderId := AuthorLeaderIdFieldValue;
        Result.FullName := AuthorNameFieldValue;
        Result.Speciality := AuthorSpecialityFieldValue;

      end;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := AuthorDepartmentIdFieldValue;

      if not VarIsNull(Result.DepartmentInfoDTO.Id) then begin

        Result.DepartmentInfoDTO.Code := AuthorDepartmentCodeFieldValue;
        Result.DepartmentInfoDTO.Name := AuthorDepartmentNameFieldValue;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentDTOFromDataSetMapper.MapDocumentResponsibleInfoDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentResponsibleInfoDTO;
begin

  Result := TDocumentResponsibleInfoDTO.Create;

  try

    with DocumentInfoHolder do begin

      Result.Id := ResponsibleIdFieldValue;

      if not VarIsNull(Result.Id) then begin

        Result.Name := ResponsibleNameFieldValue;
        Result.TelephoneNumber := ResponsibleTelephoneNumberFieldValue;

      end;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := ResponsibleDepartmentIdFieldValue;

      if not VarIsNull(Result.DepartmentInfoDTO.Id) then begin

        Result.DepartmentInfoDTO.Code := ResponsibleDepartmentCodeFieldValue;
        Result.DepartmentInfoDTO.Name := ResponsibleDepartmentNameFieldValue;

      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TDocumentDTOFromDataSetMapper.MapDocumentSigningsInfoDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentSigningsInfoDTO;
var
    DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
    HandledDocumentSigningIds: TVariantList;
begin

  HandledDocumentSigningIds := TVariantList.Create;
  
  try

    Result := CreateDocumentSigningsInfoDTOInstance;

    try

      with DocumentInfoHolder do begin

        First;

        while not Eof do begin

          if
              not VarIsNull(SigningIdFieldValue) and
              not HandledDocumentSigningIds.Contains(SigningIdFieldValue)
          then begin

            DocumentSigningInfoDTO :=
              MapDocumentSigningInfoDTOFrom(DocumentInfoHolder);

            Result.Add(DocumentSigningInfoDTO);

            HandledDocumentSigningIds.Add(SigningIdFieldValue);

          end;

          Next;

        end;

      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;

      end;

    end;

  finally

    FreeAndNil(HandledDocumentSigningIds);

  end;

end;

function TDocumentDTOFromDataSetMapper
  .MapDocumentSigningInfoDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentSigningInfoDTO;
begin

  Result := CreateDocumentSigningInfoDTOInstance;

  try

    with DocumentInfoHolder do begin

      Result.Id := SigningIdFieldValue;
      Result.SigningDate := SigningDateFieldValue;
      Result.SignerInfoDTO := MapDocumentSignerInfoDTOFrom(DocumentInfoHolder);
      Result.ActuallySignedEmployeeInfoDTO := MapDocumentActuallySignedEmployeeInfoDTOFrom(DocumentInfoHolder);

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentDTOFromDataSetMapper.MapDocumentSignerInfoDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentInfoHolder do begin

      Result.Id := SignerIdFieldValue;

      if not VarIsNull(Result.Id) then begin

        Result.LeaderId := SignerLeaderIdFieldValue;
        Result.FullName := SignerNameFieldValue;
        Result.Speciality := SignerSpecialityFieldValue;

      end;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := SignerDepartmentIdFieldValue;

      if not VarIsNull(Result.DepartmentInfoDTO.Id) then begin

        Result.DepartmentInfoDTO.Code := SignerDepartmentCodeFieldValue;
        Result.DepartmentInfoDTO.Name := SignerDepartmentNameFieldValue;

      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentDTOFromDataSetMapper.MapDocumentActuallySignedEmployeeInfoDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

    Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentInfoHolder do begin

      Result.Id := ActualSignerIdFieldValue;

      if not VarIsNull(Result.Id) then begin

        Result.LeaderId := ActualSignerLeaderIdFieldValue;
        Result.FullName := ActualSignerNameFieldValue;
        Result.Speciality := ActualSignerSpecialityFieldValue;

      end;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := ActualSignerDepartmentIdFieldValue;

      if not VarIsNull(Result.DepartmentInfoDTO.Id) then begin

        Result.DepartmentInfoDTO.Code := ActualSignerDepartmentCodeFieldValue;
        Result.DepartmentInfoDTO.Name := ActualSignerDepartmentNameFieldValue;

      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;
  
end;

end.
