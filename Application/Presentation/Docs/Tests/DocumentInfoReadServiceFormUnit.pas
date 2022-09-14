unit DocumentInfoReadServiceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  DocumentInfoReadService,
  BasedOnPostgresDocumentInfoReadService,
  BasedOnDatabaseDocumentInfoReadService,
  DocumentFullInfoDTO, ZConnection;

type
  TDocumentInfoReadServiceTestForm = class(TForm)
    Button1: TButton;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure RunDocumentInfoReadServieTest;
    
  public
    { Public declarations }
  end;

var
  DocumentInfoReadServiceTestForm: TDocumentInfoReadServiceTestForm;

implementation

{$R *.dfm}

procedure TDocumentInfoReadServiceTestForm.Button1Click(Sender: TObject);
begin

  RunDocumentInfoReadServieTest;

end;

procedure TDocumentInfoReadServiceTestForm.FormCreate(Sender: TObject);
begin

  ZConnection1.Connect;
  
end;

procedure TDocumentInfoReadServiceTestForm.RunDocumentInfoReadServieTest;
var DocumentInfoReadService: IDocumentInfoReadService;
    DocumentFullInfoDTO: TDocumentFullInfoDTO;
    Charge: TDocumentChargeInfoDTO;
    Signing: TDocumentSigningInfoDTO;
    Relation: TDocumentRelationInfoDTO;
    DocFile: TDocumentFileInfoDTO;
    SchemaData: TDocumentDbSchemaData;
begin

  SchemaData := TDocumentDbSchemaData.Create;

  SchemaData.DocumentTableName := 'doc.service_notes';
  SchemaData.DocumentChargesTableName := 'doc.service_note_receivers';
  SchemaData.DocumentLinksTableName := 'doc.service_note_links';
  SchemaData.DocumentApprovingsTableName := 'doc.service_note_approvings';
  SchemaData.DocumentFileMetadataTableName := 'doc.service_note_file_metadata';
  SchemaData.LookedDocumentsTableName := 'doc.looked_service_notes';
  
  DocumentInfoReadService :=
    TBasedOnPostgresDocumentInfoReadService.Create(
      ZConnection1,
      SchemaData
    );

  DocumentFullInfoDTO := DocumentInfoReadService.GetDocumentFullInfo(227295);

  for Charge in DocumentFullInfoDTO.DocumentDTO.ChargesInfoDTO do
  begin

    OutputDebugString(PChar(Charge.PerformerInfoDTO.FullName));
  end;

  for Signing in DocumentFullInfoDTO.DocumentDTO.SigningsInfoDTO do
  begin
         OutputDebugString(PChar(Signing.SignerInfoDTO.FullName));
  end;

  for Relation in DocumentFullInfoDTO.DocumentRelationsInfoDTO do begin

              OutputDebugString(PChar(Relation.RelatedDocumentName));
  end;

  for DocFile in DocumentFullInfoDTO.DocumentFilesInfoDTO do begin

    OutputDebugString(PChar(DocFile.FilePath));

  end;

end;

end.
