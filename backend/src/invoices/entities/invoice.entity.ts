import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

export enum InvoiceStatus {
  DRAFT = 'draft',
  SENT = 'sent',
  PAID = 'paid',
  OVERDUE = 'overdue',
  CANCELLED = 'cancelled',
}

@Entity('invoices')
export class Invoice extends BaseEntity {
  @Column()
  invoiceNumber: string;

  @Column()
  customerId: string;

  @Column({ nullable: true })
  bookingId: string;

  @Column({ type: 'simple-json' })
  lineItems: { description: string; quantity: number; unitPrice: number; total: number }[];

  @Column({ type: 'float' })
  subtotal: number;

  @Column({ type: 'float', default: 0 })
  tax: number;

  @Column({ type: 'float', default: 0 })
  discount: number;

  @Column({ type: 'float' })
  total: number;

  @Column({ type: 'text', default: InvoiceStatus.DRAFT })
  status: InvoiceStatus;

  @Column({ nullable: true })
  dueDate: Date;

  @Column({ nullable: true })
  paidAt: Date;

  @Column({ nullable: true })
  notes: string;
}
