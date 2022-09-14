unit NewDocumentInfoDTO;

interface

uses

  DocumentFullInfoDTO,
  SysUtils,
  Classes;

type

  TNewDocumentInfoDTO = class

    public

      DocumentDTO: TDocumentDTO;
      DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
      DocumentFilesInfoDTO: TDocumentFilesInfoDTO;

      destructor Destroy; override;
      
  end;
  
implementation

{ TNewDocumentInfoDTO }

destructor TNewDocumentInfoDTO.Destroy;
begin

  FreeAndNil(DocumentDTO);
  FreeAndNil(DocumentRelationsInfoDTO);
  FreeAndNil(DocumentFilesInfoDTO);
  
  inherited;

end;

end.
