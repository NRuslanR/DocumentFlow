unit DepartmentDocumentsReferenceFormProcessor;

interface

uses

  DocumentsReferenceFormProcessor,
  DocumentsReferenceFormProcessorDecorator,
  DocumentsReferenceForm,
  DocumentSetHolder,
  SysUtils;

type

  TDepartmentDocumentsReferenceFormProcessor =
    class (TDocumentsReferenceFormProcessorDecorator)

      protected

         procedure InternalSetDocumentReferenceFormColumns(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          FieldDefs: TDocumentSetFieldDefs
         ); override;

    end;

implementation

uses

  BaseDocumentsReferenceFormUnit;

{ TDepartmentDocumentsReferenceFormProcessor }

procedure TDepartmentDocumentsReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited;

  with TBaseDocumentsReferenceForm(DocumentsReferenceForm.Self) do begin

    ApplicationsExistsColumn.DataBinding.FieldName := '';
    ApplicationsExistsColumn.VisibleForCustomization := False;
    ApplicationsExistsColumn.Visible := False;
    
  end;

end;

end.
