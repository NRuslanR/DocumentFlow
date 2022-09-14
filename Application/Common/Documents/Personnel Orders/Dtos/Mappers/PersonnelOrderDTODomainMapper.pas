unit PersonnelOrderDTODomainMapper;

interface

uses

  IDocumentUnit,
  DocumentFullInfoDTO,
  DocumentObjectsDTODomainMapper,
  Employee,
  PersonnelOrderFullInfoDTO,
  ChangedDocumentInfoDTO,
  ChangedPersonnelOrderDto,
  PersonnelOrder,
  SysUtils;

type

  TPersonnelOrderDTODomainMapper = class (TDocumentObjectsDTODomainMapper)

    public

      function MapNewDocumentFrom(
        DocumentDTO: TDocumentDTO;
        RequestingEmployee: TEmployee
      ): IDocument; override;

      function MapChangedDocumentFrom(
        Document: IDocument;
        ChangingEmployee: TEmployee;
        ChangedDocumentDTO: TChangedDocumentDTO
      ): IDocument; override;
    
  end;

implementation

{ TPersonnelOrderDTODomainMapper }

function TPersonnelOrderDTODomainMapper.MapChangedDocumentFrom(
  Document: IDocument;
  ChangingEmployee: TEmployee;
  ChangedDocumentDTO: TChangedDocumentDTO
): IDocument;
var
    ChangedPersonnelOrderDto: TChangedPersonnelOrderDto;
begin

  Result := inherited MapChangedDocumentFrom(Document, ChangingEmployee, ChangedDocumentDTO);

  ChangedPersonnelOrderDto := ChangedDocumentDTO as TChangedPersonnelOrderDto;
  
  with Document.Self as TPersonnelOrder do begin

    SubKindId := ChangedPersonnelOrderDto.SubKindId;
    
  end;

end;

function TPersonnelOrderDTODomainMapper.MapNewDocumentFrom(
  DocumentDTO: TDocumentDTO;
  RequestingEmployee: TEmployee
): IDocument;
var
    PersonnelOrderDto: TPersonnelOrderDTO;
begin

  Result := inherited MapNewDocumentFrom(DocumentDTO, RequestingEmployee);

  PersonnelOrderDto := DocumentDTO as TPersonnelOrderDTO;

  with Result.Self as TPersonnelOrder do begin

    SubKindId := PersonnelOrderDto.SubKindId;
    
  end;

end;

end.
