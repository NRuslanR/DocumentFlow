unit DocumentChargeSheetNotifyingMessageBuilder;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  Document,
  DocumentFileUnit,
  MessagingServiceUnit,
  DepartmentUnit,
  Employee;

type

  IDocumentChargeSheetNotifyingMessageBuilder = interface

    function BuildNotifyingMessageForNewDocumentChargeSheet(
      NewDocumentChargeSheet: IDocumentChargeSheet;
      RelatedDocument: TDocument;
      RelatedDocumentFiles: TDocumentFiles;
      RelatedDocumentResponsible: TEmployee;
      RelatedDocumentResponsibleDepartment: TDepartment;
      SenderEmployee: TEmployee;
      ReceiverEmployees: TEmployees
    ): IMessage;

    function BuildNotifyingMessageForChangedDocumentChargeSheet(
      ChangedDocumentChargeSheet: IDocumentChargeSheet;
      RelatedDocument: TDocument;
      RelatedDocumentFiles: TDocumentFiles;
      RelatedDocumentResponsible: TEmployee;
      RelatedDocumentResponsibleDepartment: TDepartment;
      SenderEmployee: TEmployee;
      ReceiverEmployees: TEmployees
    ): IMessage;

    function BuildNotifyingMessageForRemovedDocumentChargeSheet(
      RemovedDocumentChargeSheet: IDocumentChargeSheet;
      RelatedDocument: TDocument;
      RelatedDocumentFiles: TDocumentFiles;
      RelatedDocumentResponsible: TEmployee;
      RelatedDocumentResponsibleDepartment: TDepartment;
      SenderEmployee: TEmployee;
      ReceiverEmployees: TEmployees
    ): IMessage;
    
  end;

implementation

end.
