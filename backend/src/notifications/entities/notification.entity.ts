import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

export enum NotificationType {
  BOOKING = 'booking',
  PAYMENT = 'payment',
  PROMOTION = 'promotion',
  SYSTEM = 'system',
  REVIEW = 'review',
}

@Entity('notifications')
export class Notification extends BaseEntity {
  @Column()
  userId: string;

  @Column()
  title: string;

  @Column({ type: 'text' })
  body: string;

  @Column({ type: 'text', default: NotificationType.SYSTEM })
  type: NotificationType;

  @Column({ default: false })
  isRead: boolean;

  @Column({ nullable: true })
  referenceId: string;

  @Column({ nullable: true })
  referenceType: string;

  @Column({ nullable: true })
  imageUrl: string;
}
