unit PersonnelOrderMainInformationFormViewModelMapper;

interface

uses

  DocumentMainInformationFormViewModelMapper,
  DocumentFullInfoDTO,
  PersonnelOrderFullInfoDTO,
  DocumentMainInformationFormViewModelUnit,
  PersonnelOrderMainInformationFormViewModel,
  ChangedDocumentInfoDTO,
  ChangedPersonnelOrderDto,
  SysUtils;

type

  TPersonnelOrderMainInformationFormViewModelMapper =
    class (TDocumentMainInformationFormViewModelMapper)

      protected

        function CreateDocumentMainInformationFormViewModelInstance:
          TDocumentMainInformationFormViewModel; override;

      protected

        procedure FillDocumentMainInformationFormViewModel(
          ViewModel: TDocumentMainInformationFormViewModel;
          DocumentDTO: TDocumentDTO
        ); override;

        procedure FillNewDocumentDTOByViewModel(
          DocumentDTO: TDocumentDTO;
          ViewModel: TDocumentMainInformationFormViewModel
        ); override;

        procedure FillChangedDocumentDTOByViewModel(
          ChangedDocumentDTO: TChangedDocumentDTO;
          ViewModel: TDocumentMainInformationFormViewModel
        ); override;
        
      protected

        function CreateChangedDocumentDTOInstance: TChangedDocumentDTO; override;
        function CreateNewDocumentDTOInstance: TDocumentDTO; override;

      public

        function CreateEmptyDocumentMainInformationFormViewModel:
          TDocumentMainInformationFormViewModel; override;

    end;
  
implementation

uses

  AuxDebugFunctionsUnit;
  
{ TPersonnelOrderMainInformationFormViewModelMapper }

function TPersonnelOrderMainInformationFormViewModelMapper.CreateChangedDocumentDTOInstance: TChangedDocumentDTO;
begin

  Result := TChangedPersonnelOrderDto.Create;

end;

function TPersonnelOrderMainInformationFormViewModelMapper.
  CreateDocumentMainInformationFormViewModelInstance: TDocumentMainInformationFormViewModel;
begin

  Result := TPersonnelOrderMainInformationFormViewModel.Create;
  
end;

function TPersonnelOrderMainInformationFormViewModelMapper.
  CreateEmptyDocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel;
begin

  Result := inherited CreateEmptyDocumentMainInformationFormViewModel;

  Result.Kind := 'Кадровый приказ';
  Result.CreationDate := Now;

end;

function TPersonnelOrderMainInformationFormViewModelMapper.CreateNewDocumentDTOInstance: TDocumentDTO;
begin

  Result := TPersonnelOrderDTO.Create;
  
end;

procedure TPersonnelOrderMainInformationFormViewModelMapper.FillChangedDocumentDTOByViewModel(
  ChangedDocumentDTO: TChangedDocumentDTO;
  ViewModel: TDocumentMainInformationFormViewModel
);
var
    ChangedPersonnelOrderDto: TChangedPersonnelOrderDto;
begin

  inherited FillChangedDocumentDTOByViewModel(ChangedDocumentDTO, ViewModel);

  ChangedPersonnelOrderDto := TChangedPersonnelOrderDto(ChangedDocumentDTO);

  with ViewModel as TPersonnelOrderMainInformationFormViewModel do begin

    ChangedPersonnelOrderDto.SubKindId := SubKindId;
    
  end;
  
end;

procedure TPersonnelOrderMainInformationFormViewModelMapper.FillDocumentMainInformationFormViewModel(
  ViewModel: TDocumentMainInformationFormViewModel;
  DocumentDTO: TDocumentDTO
);
var
    PersonnelOrderDto: TPersonnelOrderDTO;
begin

  inherited FillDocumentMainInformationFormViewModel(ViewModel, DocumentDTO);

  PersonnelOrderDto := DocumentDTO as TPersonnelOrderDTO;

  with TPersonnelOrderMainInformationFormViewModel(ViewModel) do begin

    SubKindId := PersonnelOrderDto.SubKindId;
    SubKindName := PersonnelOrderDto.SubKindName;
    
  end;

end;

procedure TPersonnelOrderMainInformationFormViewModelMapper.FillNewDocumentDTOByViewModel(
  DocumentDTO: TDocumentDTO;
  ViewModel: TDocumentMainInformationFormViewModel
);
var
    PersonnelOrderDto: TPersonnelOrderDTO;
begin

  inherited FillNewDocumentDTOByViewModel(DocumentDTO, ViewModel);

  PersonnelOrderDto := TPersonnelOrderDTO(DocumentDTO);
  
  with ViewModel as TPersonnelOrderMainInformationFormViewModel do begin

    PersonnelOrderDto.SubKindId := SubKindId;
    PersonnelOrderDto.SubKindName := SubKindName;
    
  end;

end;

end.
